import sys, os, csv, statistics
import matplotlib.pyplot as plt
import numpy as np
import fft_test as fft

def process(inFile, plot_save_dir=None, window = None):
    print("Input file name : ",inFile)
    y0 = np.loadtxt(inFile, dtype=int)
    y0 = y0[:2048]
    #y0 = y0[2048:4096]
    SNDR, ENOB, SFDR, THD, plt = fft.AnalyzeDynamicADC(y0, 2048, 2, window)
    if plot_save_dir is not None: 
        plt.savefig('{}fft_{}.png'.format(plot_save_dir, inFile[inFile.rindex('/')+1:]), dpi=500)
        plt.close()
        plt.figure().clear()
    return [SNDR, ENOB, SFDR, THD] 

def process_multi(inDir, plot=True, window = None):
    for root, dirs, files in os.walk(inDir):
        if "analysis" in root:
            continue
        graph_dir = None
        if plot:
            graph_dir = "fft_graphs"+root[len(inDir):]+"/"
            try:
                os.mkdir(graph_dir)
            except Exception:
                pass
        if not files or files[0].find("Sinusoid") == -1:
            continue
        output = open("fft_analysis.csv", "a+")
        writer = csv.writer(output)
        writer.writerow([root, "SNDR", "ENOB", "SFDR", "THD"])
        for inFile in files:
            if inFile[-3:]!="txt":
                continue
            writer.writerow([inFile] + process(root +'/'+ inFile, graph_dir, window))
        output.close()


def parser(linearity_file):
    int_parser = lambda s: (int(s[0:2]), 2) if len(s)>1 and s[1].isdigit() else (int(s[0]), 1)
    with open(linearity_file, 'r') as f:
        reader = csv.reader(f)
        parsed = [["Channel", "SDC/SE", "Frozen/SHA","ENOB"]]
        for r in reader:
            r_p = []
            if r[1] == "SNDR":
                path = r[0]
                ch_i = path.find("ch")+2
                ch, i = int_parser(path[ch_i:])
                adc0ch, adc1ch = None, None
                if ch < 8:
                    adc0ch = ch
                else:
                    adc1ch = ch
                if len(path) > (ch_i+i) and path[ch_i+i] == "_":
                    ch, i = int_parser(path[ch_i+i+1:])
                    if ch < 8:
                        adc0ch = ch
                    else:
                        adc1ch = ch
                no_cal = "NoCal" in r[0]
            else:
                if no_cal:
                    continue
                header = r[0]
                if "ADC0" in header:
                    if adc0ch is not None:
                        r_p.append(adc0ch)
                    else:
                        continue
                else:
                    if adc1ch is not None:
                        r_p.append(adc1ch)
                    else:
                        continue
                if "SDC" in header:
                    r_p.append("SDC")
                else:
                    r_p.append("SE")
                if "FrozenSHA" in header:
                    r_p.append("FrozenSHA")
                else:
                    r_p.append("SHA")
                r_p.append(float(r[2]))
                parsed.append(r_p)

    with open("fft_parsed.csv", "w+") as f:
        writer=csv.writer(f)
        writer.writerows(parsed)
    return parsed

def all_stats(parsed, per_channel):
    if per_channel:
        sorted_r = sorted(parsed[1:], key=lambda x: x[0:3])
        ch, sha = sorted_r[0][0], sorted_r[0][2]
    else:
        sorted_r = sorted(parsed[1:], key=lambda x: x[1:3])
        ch, sha = None, sorted_r[0][2]
    avgs = [[]]
    samples = []
    for r in sorted_r:
        if r[2] != sha:
            sha = r[2]
            samples = [list(s) for s in zip(*samples)]
            avgs[-1].append([statistics.mean(s) for s in samples])
            samples = []
        if ch is not None and r[0]!= ch:
            ch = r[0]
            avgs.append([])
        samples.append(r[3:7])
    samples = [list(s) for s in zip(*samples)]
    avgs[-1].append([statistics.mean(s) for s in samples])

    """ need to deal with missing channels when it happens
    for i in range(16):
        if not avgs[i]:
            avgs[i] = [[0,0,0,0] for _ in range(4)]
    """
    """
    avgs[0] = [[0] for _ in range(4)]
    avgs[8] = [[0] for _ in range(4)]
    """
    avgs = np.array(avgs).transpose(1,2,0)
    return [avgs, ["SDC-FrozenSHA", "SDC-SHA", "SE-FrozenSHA", "SE-SHA"]]

def grapher(data, labels, per_channel):
    def autolabel(rects):
        """Attach a text label above each bar in *rects*, displaying its height."""
        for rect in rects:
            height = rect.get_height()
            ax.annotate('{0:.2f}'.format(height),
                        xy=(rect.get_x() + rect.get_width() / 2, height),
                        xytext=(0, 3 if height>0 else -10),  # 3 points vertical offset
                        size=6,
                        textcoords="offset points",
                        ha='center', va='bottom')
    x = np.arange(len(data[0][0]))
    width = 0.1
    offset = len(labels)/2

    fig, ax = plt.subplots()
    title = 'ENOB'
    ax.set_title(title)
    ax.set_ylabel(title)
    for i, lab in enumerate(labels):
        autolabel(ax.bar(x+(i-offset)*width, data[i][0], width, label=lab))
    if per_channel:
        ax.set_xlabel('Channel')
        ax.set_xticks(x)
        ax.legend(bbox_to_anchor=(1., 1.))
    else:
        ax.set_xlabel('(Aggregated over all channels)')
        #ax.set_xticks([])
        plt.xticks(x, ["Warm", "Cold (windowed)"])
        ax.legend(bbox_to_anchor=(.9, .9))
    plt.show()

def compare(warm, cold, stats, per_channel):
    warm_data, warm_label = stats(parser(warm), per_channel)
    cold_data, cold_label = stats(parser(cold), per_channel)
    if per_channel:
        for i in range(len(warm_label)):
            warm_label[i]+="_Warm"
        for i in range(len(cold_label)):
            cold_label[i]+="_Cold (windowed)"
        grapher(np.concatenate((warm_data, cold_data)), warm_label+cold_label, per_channel)
    else:
        combined = np.array([warm_data, cold_data]).transpose(1,2,0,3).squeeze(3)
        grapher(combined, warm_label, per_channel)

linearity_statistics = lambda lin_file, stats, per_channel: grapher(*(stats(parser(lin_file), per_channel)+[per_channel]))
#process_multi("data_ethlu/cold", False, window = np.hanning(2048))
WARM = "data_ethlu/warm/analysis/fft_analysis.csv"
COLD = "data_ethlu/cold/analysis/fft_analysis.csv"
COLD_WINDOW = "data_ethlu/cold/analysis/fft_analysis_hanning_20.csv"
#linearity_statistics(COLD_WINDOW, all_stats, True)
#linearity_statistics("fft_analysis.csv", all_stats, True)
compare(WARM, COLD_WINDOW, all_stats, False)
#print(process("data_ethlu/cold/ch1_10/Sinusoid_20KHz_SDC-FrozenSHA-ADC0_NomVREFPN_2M_v2.txt", None, np.hanning(2048)))
#print(process("data_ethlu/cold/ch0_8/Sinusoid_20KHz_SDC-SHA-ADC1_NomVREFPN_2M_v2.txt", None, None))

