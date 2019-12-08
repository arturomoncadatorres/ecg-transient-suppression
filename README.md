# ECG IIR Notch Filtering Using Transient Suppression
---

This is the [Python](./python) and [MATLAB](./matlab) implementation of the algorithm proposed in
the paper:

> Pei, Soo-Chang, and Chien-Cheng Tseng.["Elimination of AC interference in electrocardiogram using IIR notch filter with transient suppression."](https://ieeexplore.ieee.org/abstract/document/469385) IEEE transactions on biomedical engineering 42.11 (1995): 1128-1132.

Full credit goes to the authors.

This technique uses vector projection to minimize the problem of transient values, common to the use of IIR filters:

![Median-based template of a cardiac cycle](./images/ecg_transient_suppression.png)

The top signal corresponds to the original ECG signal with AC interference noise. The middle signal corresponds to the filtered ECG signal using a typical IIR notch filter. The bottom signal corresponds to the filtered signal using an IIR notch filter with the proposed transient suppression technique.

An [example ECG signal](./data/ecg.mat) is included (as a .mat file) for quick
testing of the algorithm, which was obtained from the [MIT-BIH Polysomnographic Database](http://www.physionet.org/cgi-bin/atm/ATM).
