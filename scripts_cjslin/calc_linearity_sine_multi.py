import numpy as np
import matplotlib.pyplot as plt
import math, statistics
import sys, os
import csv

#the numbers of extreme values to average over and report, e.g. 5 means the average of 5 lowest/highest
EXTREMA = [1, 5, 10] 

MAX_E = max(EXTREMA) 

def process(inFile, plot_save_dir=None):
    print("Input file name : ",inFile)
    Codes16 = np.loadtxt(inFile,dtype=int)

    #Codes16 = [0,0,1,2,3,4,5,6,7,8]
    Codes12 = []
    for CurrentCode in Codes16:
            Codes12.append(int(np.floor(CurrentCode/16)))

    # the histogram of the data
    #minbin = 150
    #maxbin = 3900
    minbin = min(Codes12)+100
    maxbin = max(Codes12)-100

    print("Min/max code (12bit)=",min(Codes12),max(Codes12))

    # histogram in numpy returns bin edges, but hisogram in matlab uses 
    # bin centers
    # to simplify calculations use bin centers, so we calculate edges to get
    # the centers that we want
    bins = []
    for myBin in range(minbin,maxbin+2):
        bins.append(myBin - 0.5)   # bin center
        # add extra binedges to capture values above and below final edges
    bins.append(4096.5)    
    bins = np.insert(bins,0,0.0)

    # find histrogram
    h,binedges = np.histogram(Codes12,bins)
    i = 1
    while h[i] < 10 or h[i] < h[i+1]:
        i+=1
    j = -1
    while h[j] < 10 or h[j] < h[j-1]:
        j-=1

    # cumulative historgram
    ch = np.cumsum(h)

    # find transition levels
    histosum = np.sum(h)
    T = []
    for CurrentLevel in range(np.size(ch)):
        #print(CurrentLevel)
        T.append(-math.cos(math.pi*ch[CurrentLevel]/histosum))

    # linearized historgram
    end = np.size(T)
    hlin = []
    hlin = np.subtract(T[1:end],T[0:end-1])

    # truncate at least first and last bin, more if input did not clip ADC
    #trunc = 10
    #hlin_trunc = hlin[trunc:np.size(hlin)-trunc]
    hlin_trunc = hlin[i:j]

    # calculate LSB size and DNL
    lsb = np.sum(hlin_trunc) / np.size(hlin_trunc)
    dnl = 0
    dnl = [hlin_trunc/lsb-1]
    # define 0th DNL value as 0
    dnl = np.insert(dnl,0,0.0)
    # calculate inl
    inl = np.cumsum(dnl)
    #normalize inl plot
    inlMean = np.mean(inl)
    inlNorm=inl-(inlMean)

    dnl_min, dnl_max, inl_min, inl_max = [], [], [], []
    dnl_min_inds = np.argpartition(dnl, MAX_E)[:MAX_E]
    dnl_mins = np.sort(dnl[dnl_min_inds])
    dnl_max_inds = np.argpartition(dnl, -MAX_E)[-MAX_E:]
    dnl_maxs = np.sort(dnl[dnl_max_inds])
    inl_min_inds = np.argpartition(inlNorm, MAX_E)[:MAX_E]
    inl_mins = np.sort(inlNorm[inl_min_inds])
    inl_max_inds = np.argpartition(inlNorm, -MAX_E)[-MAX_E:]
    inl_maxs = np.sort(inlNorm[inl_max_inds])

    for e in EXTREMA:
        dnl_min.append(np.average(dnl_mins[:e]))
        dnl_max.append(np.average(dnl_maxs[-e:]))
        inl_min.append(np.average(inl_mins[:e]))
        inl_max.append(np.average(inl_maxs[-e:]))
    #print(dnl_min, dnl_max, inl_min, inl_max)

    if plot_save_dir:
        code = np.arange(i,i+len(dnl))
        # convert to int
        code = code.astype(int)

        # make plots
        plt.gcf().clear()
        fig = plt.figure(1)
        
        dnl_axes = fig.add_subplot(211)
        dnl_axes.plot(code,dnl)
        dnl_axes.plot(dnl_min_inds,dnl[dnl_min_inds], 'r+')
        dnl_axes.plot(dnl_max_inds,dnl[dnl_max_inds], 'g+')

        plt.ylabel('DNL [LSB]')
        dnl_axes.set_title(r'ColdADC Static Linearity ($f_{in}$=20.5 kHz, $V_{p-p}$=1.4V)')
        dnl_axes.set_autoscaley_on(True)
        #dnl_axes.set_ylim([-0.5,0.5])

        inl_axes = fig.add_subplot(212)
        inl_axes.plot(code,inlNorm)
        inl_axes.plot(inl_min_inds,inlNorm[inl_min_inds], 'r+')
        inl_axes.plot(inl_max_inds,inlNorm[inl_max_inds], 'g+')

        plt.xlabel('ADC Code')
        plt.ylabel('INL [LSB]')
        inl_axes.set_autoscaley_on(True)
        #inl_axes.set_ylim([-1.0,1.5])

        plt.savefig('{}linearity_{}.png'.format(plot_save_dir, inFile[inFile.rindex('/')+1:]), dpi=500)

        """
        plt.figure(2)
        plt.plot(h[i:j])

        plt.savefig('histo_{}.png'.format(inFile[inFile.rindex('/')+1:]), dpi=500)

        plt.show()
        """
    return [dnl_min, dnl_max, inl_min, inl_max, inlMean]
     

def process_multi(inDir):
    output = open("linearity_analysis.csv", "a+")
    writer = csv.writer(output)
    writer.writerow([inDir, "dnl_mins", "dnl_maxs", "inl_mins", "inl_maxs", "inl_mean", EXTREMA])

    for buff in ["SE-", "SDC-"]:
        for mux in ["SHA-", "FrozenSHA-"]:
            for adc in ["ADC0_", "ADC1_"]:
                for v in ["v1.txt", "v2.txt"]:
                    inFile = "Sinusoid_20Khz_"+buff+mux+adc+"NomVREFPN_2M_"+v
                    writer.writerow([inFile] + process(inDir+inFile))

    output.close()

def process_graph_multi(inDir):
    """ Saves the graphs of linearity of the sample files in 'inDir' into 'graph_dir'. """
    for buff in ["SE-", "SDC-"]:
        for mux in ["SHA-", "FrozenSHA-"]:
            for adc in ["ADC0_", "ADC1_"]:
                for v in ["v1.txt", "v2.txt"]:
                    inFile = "Sinusoid_20Khz_"+buff+mux+adc+"NomVREFPN_2M_"+v
                    graph_dir = "lin_graphs"+inDir[inDir.find("/"):]
                    try:
                        os.mkdir(graph_dir)
                    except Exception:
                        pass
                    process(inDir+inFile, graph_dir)

def parser(linearity_file):
    with open(linearity_file, 'r') as f:
        reader = csv.reader(f)
        parsed = [["Channel", "SDC/SE", "Frozen/SHA","dnl_min", "dnl_max", "inl_min", "inl_max", "inl_mean"]]
        for r in reader:
            r_p = []
            if r[1] == "dnl_mins":
                channels = int(r[0][r[0].find("ch")+2])
                no_cal = "NoCal" in r[0]
            else:
                if no_cal:
                    continue
                header = r[0]
                if "ADC0" in header:
                    r_p.append(channels)
                else:
                    r_p.append(channels+8)
                if "SDC" in header:
                    r_p.append("SDC")
                else:
                    r_p.append("SE")
                if "FrozenSHA" in header:
                    r_p.append("FrozenSHA")
                else:
                    r_p.append("SHA")
                for i in range(1,5):
                    extremas = [float(s) for s in r[i][1:-1].split(',')]
                    r_p.append(extremas[0])
                r_p.append(float(r[5]))
                parsed.append(r_p)

    """
    with open("linearity_parsed.csv", "w+") as f:
        writer=csv.writer(f)
        writer.writerows(parsed)
    """
    return parsed

def grapher(parsed):
    sorted_r = sorted(parsed[1:], key=lambda x: x[0:3])
    avgs = [[] for _ in range(16)]
    ch, sha = 0, "FrozenSHA"
    samples = []
    for r in sorted_r:
        if r[2] != sha:
            sha = r[2]
            samples = [list(s) for s in zip(*samples)]
            avgs[ch].append([statistics.mean(s) for s in samples])
            samples = []
        if r[0] != ch:
            ch = r[0]
        samples.append(r[3:7])
    samples = [list(s) for s in zip(*samples)]
    avgs[ch].append([statistics.mean(s) for s in samples])

    for i in range(16):
        if not avgs[i]:
            avgs[i] = [[0,0,0,0] for _ in range(4)]

    avgs = np.array(avgs).transpose(1,0,2)

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

    x = np.arange(16)
    width = 0.2

    fig, ax = plt.subplots()
    ax.set_ylabel('(Averaged) Extrema DNL (12 bit)')
    ax.set_xlabel('Channel')
    ax.set_xticks(x)
    ax.set_title('(Averaged) Extrema DNL (12 bit)')
    autolabel(ax.bar(x-1.5*width, avgs[0][:,1], width, label='SDC-FrozenSHA'))
    autolabel(ax.bar(x-.5*width, avgs[1][:,1], width, label='SDC-SHA'))
    autolabel(ax.bar(x+.5*width, avgs[2][:,1], width, label='SE-FrozenSHA'))
    autolabel(ax.bar(x+1.5*width, avgs[3][:,1], width, label='SE-SHA'))
    autolabel(ax.bar(x-1.5*width, avgs[0][:,0], width, label='SDC-FrozenSHA'))
    autolabel(ax.bar(x-.5*width, avgs[1][:,0], width, label='SDC-SHA'))
    autolabel(ax.bar(x+.5*width, avgs[2][:,0], width, label='SE-FrozenSHA'))
    autolabel(ax.bar(x+1.5*width, avgs[3][:,0], width, label='SE-SHA'))
    ax.legend(bbox_to_anchor=(1.1, 1.05))

    fig, ax = plt.subplots()
    ax.set_ylabel('(Averaged) Extrema INL (12 bit)')
    ax.set_xlabel('Channel')
    ax.set_xticks(x)
    ax.set_title('(Averaged) Extrema INL (12 bit)')
    autolabel(ax.bar(x-1.5*width, avgs[0][:,3], width, label='SDC-FrozenSHA'))
    autolabel(ax.bar(x-.5*width, avgs[1][:,3], width, label='SDC-SHA'))
    autolabel(ax.bar(x+.5*width, avgs[2][:,3], width, label='SE-FrozenSHA'))
    autolabel(ax.bar(x+1.5*width, avgs[3][:,3], width, label='SE-SHA'))
    autolabel(ax.bar(x-1.5*width, avgs[0][:,2], width, label='SDC-FrozenSHA'))
    autolabel(ax.bar(x-.5*width, avgs[1][:,2], width, label='SDC-SHA'))
    autolabel(ax.bar(x+.5*width, avgs[2][:,2], width, label='SE-FrozenSHA'))
    autolabel(ax.bar(x+1.5*width, avgs[3][:,2], width, label='SE-SHA'))
    ax.legend(bbox_to_anchor=(1.1, 1.05))

    plt.show()

linearity_statistics = lambda lin_file: grapher(parser(lin_file))

if __name__!="__main__":
    BASE = "data_ethlu/"
    for ch in range(0, 8):
        inDir = BASE+"ch{}_{}/".format(ch, ch+8)
        try:
            process_graph_multi(inDir)
        except Exception as e:
            print("bad inDir", inDir)
            print(e)
        for inDir in os.scandir(inDir):
            if inDir.is_dir():
                try:
                    process_graph_multi(inDir.path+'/')
                except Exception:
                    print("bad inDir", inDir.path)


#print(process("data_ethlu/ch3_11/Sinusoid_20KHz_SE-SHA-ADC0_NomVREFPN_2M_v2.txt", "./"))
linearity_statistics("data_ethlu/analysis/linearity_analysis_trunc_limit.csv")
