import sys, os, csv
import matplotlib.pyplot as plt
import numpy as np
import fft_test as fft
from combined_analysis import all_stats, SDC_stats, SHA_stats, single_stats, all_stats_db, find_chs

def process(inFile, plot_save_dir=None, window = None):
    print("Input file name : ",inFile)
    y0 = np.loadtxt(inFile, dtype=int)
    y0 = y0[:2048]
    #y0 = y0[2048:4096]
    SNDR, ENOB, SFDR, THD, plt = fft.AnalyzeDynamicADC(y0, 2048, 2, window)
    #plt.show()
    if plot_save_dir is not None: 
        plt.savefig('{}fft_{}.png'.format(plot_save_dir, inFile[inFile.rindex('/')+1:]), dpi=500)
        plt.close()
        plt.figure().clear()
    return [SNDR, ENOB, SFDR, THD] 

#print(process('data_ethlu/cold/ch2_11/Sinusoid_20KHz_SE-SHA-ADC0_NomVREFPN_2M_v1.txt', "./"))

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
                continue
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


def parser(linearity_file, exam_no_cal = False):
    with open(linearity_file, 'r') as f:
        reader = csv.reader(f)
        parsed = [["Channel", "SDC/SE", "Frozen/SHA","ENOB"]]
        for r in reader:
            r_p = []
            if r[1] == "SNDR":
                path = r[0]
                adc0ch, adc1ch, misc = find_chs(path)
                no_cal = "NoCal" in r[0]
            else:
                if no_cal != exam_no_cal:
                    continue
                if adc0ch is not None and adc0ch < 7 and misc is None:
                    pass
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
                if "DB" in header:
                    if "DBypass" in header:
                        r_p.append("DBypass")
                    else:
                        r_p.append("DB")
                else:
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

def grapher(data, labels, per_channel):
    def autolabel(rects):
        """Attach a text label above each bar in *rects*, displaying its height."""
        for rect in rects:
            height = rect.get_height()
            ax.annotate('{0:.2f}'.format(height),
                        xy=(rect.get_x() + rect.get_width() / 2, height),
                        xytext=(0, 3 if height>0 else -18),  # 3 points vertical offset
                        size=8,
                        textcoords="offset points",
                        ha='center', va='bottom')
    x = np.arange(len(data[0][0]))
    width = 0.1
    offset = len(labels)/2

    fig, ax = plt.subplots()
    title = 'ENOB'
    ax.set_title(title, fontsize = 40)
    ax.set_ylabel(title, fontsize = 25)
    ax.set_ylim(8, 12)
    for i, lab in enumerate(labels):
        autolabel(ax.bar(x+(i-offset)*width, data[i][0], width, label=lab))
    if per_channel:
        ax.set_xlabel('Channel', fontsize = 25)
        ax.set_xticks(x)
        ax.tick_params(axis = 'both', which = 'major', labelsize = 15)
        ax.legend(bbox_to_anchor=(1., 1.))
    else:
        for i, lab in enumerate(labels):
            ax.errorbar(x+(i-offset)*width, data[i][0], yerr=data[i][1], ecolor='black', fmt='none')
        ax.set_xlabel('(Averaged over all channels)')
        ax.set_xticks([])
        #plt.xticks(x, ["Warm", "Cold"])
        ax.legend(bbox_to_anchor=(.9, .9))
    plt.show()

def histogram(data, labels):
    fig = plt.figure()
    fig.suptitle('ENOB Histogram', fontsize = 40)
    size = int(len(labels)**0.5)
    for i, lab in enumerate(labels):
        ax = fig.add_subplot(size, size, i+1)
        ax.set_title(lab, fontsize = 30)
        #ax.set_xlabel("ENOB", fontsize = 25)
        #ax.set_ylabel("Number of channels", fontsize = 25)
        d = data[i][0]
        #bins = np.histogram_bin_edges(d, bins='auto')
        #bins = np.arange(8, 10.5, .25)
        #bins = np.arange(6.5, 8, .25)
        bins = np.arange(9.5, 11.5, .2)
        ax.hist(d, bins=bins)
        ax.text(0.1,0.9, "Mean: {:.2f}, SD: {:.2f}".format(np.mean(d), np.std(d)), transform=ax.transAxes)
        ax.set_xticks(bins)
        ax.tick_params(axis = 'both', which = 'major', labelsize = 15)
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

WARM = "data_ethlu/warm/analysis/fft_analysis.csv"
WARM2 = "data_ethlu/warm_2/analysis/fft_analysis.csv"
WARMDIFF = "data_ethlu/warm_diff/analysis/fft_analysis_nowindow.csv"
COLDDIFF = "data_ethlu/cold_diff/analysis/fft_analysis.csv"
COLD = "data_ethlu/cold/analysis/fft_analysis.csv"
COLD_WINDOW = "data_ethlu/cold/analysis/fft_analysis_hanning_20.csv"
if __name__=="__main__":
    #process_multi("data_ethlu/cold_diff", True)
    #linearity_statistics(COLDDIFF, all_stats_db, False)
    #linearity_statistics(COLDDIFF, all_stats_db, True)
    #linearity_statistics("fft_analysis.csv", all_stats, True)
    #compare(WARM, COLD_WINDOW, all_stats, False)
    #print(process("data_ethlu/warm_diff/ch1/v1/ADC0_Sinusoid_20KHz_DB-FrozenSHA_NomVREFPN_2M_v1.txt", None, np.hanning(2048)))
    #print(process("data_ethlu/warm/ch0_8/Sinusoid_20KHz_SDC-SHA-ADC1_NomVREFPN_2M_v2.txt", None, None))
    #histogram(*all_stats_db(parser(COLDDIFF), True))
    #se_sha = all_stats(parser(COLD_WINDOW), True)[0][3:]
    #grapher(se_sha, [""], True) 
    #histogram(se_sha, [""])
    pass

