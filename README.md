# Enabling Large Intelligent Surfaces with Compressive Sensing and Deep Learning
This is a MATLAB code package related to the following article: 
Abdelrahman Taha, Muhammad Alrabeiah, and Ahmed Alkhateeb, “[Enabling Large Intelligent Surfaces with Compressive Sensing and Deep Learning](https://arxiv.org/abs/1904.10136),” arXiv e-prints, p. arXiv:1904.10136, Apr 2019.
# Abstract of the Article
Employing large intelligent surfaces (LISs) is a promising solution for improving the coverage and rate of future wireless systems. These surfaces comprise a massive number of nearly-passive elements that interact with the incident signals, for example by reflecting them, in a smart way that improves the wireless system performance. Prior work focused on the design of the LIS reflection matrices assuming full knowledge of the channels. Estimating these channels at the LIS, however, is a key challenging problem, and is associated with large training overhead given the massive number of LIS elements. This paper proposes efficient solutions for these problems by leveraging tools from compressive sensing and deep learning. First, a novel LIS architecture based on sparse channel sensors is proposed. In this architecture, all the LIS elements are passive except for a few elements that are active (connected to the baseband of the LIS controller). We then develop two solutions that design the LIS reflection matrices with negligible training overhead. In the first approach, we leverage compressive sensing tools to construct the channels at all the LIS elements from the channels seen only at the active elements. These full channels can then be used to design the LIS reflection matrices with no training overhead. In the second approach, we develop a deep learning based solution where the LIS learns how to optimally interact with the incident signal given the channels at the active elements, which represent the current state of the environment and transmitter/receiver locations. We show that the achievable rates of the proposed compressive sensing and deep learning solutions approach the upper bound, that assumes perfect channel knowledge, with negligible training overhead and with less than 1% of the elements being active.
# Code Package Content
The main script for generating Figure 10, illustrated in the original article, is named "Fig10_generator.m". 
One additional MATLAB function named "Main_fn.m" is called by the main script.
![Figure10](https://github.com/Abdelrahman-Taha/LIS-DeepLearning/blob/master/Figure10.png)
The script adopts the publicly available parameterized [DeepMIMO dataset](http://deepmimo.net/) published for deep learning applications in mmWave and massive MIMO systems.

**To reproduce the results, please follow these steps:**
1. Download the code and add it to the "DeepMIMO_Dataset_Generation/RayTracing Scenarios/" folder. (Note that the DeepMIMO source data is available on [this link](http://deepmimo.net/))
2. Run the file named “Fig10_generator.m” in MATLAB and the script will sequentially execute the following tasks:
    1. Generate the inputs and outputs of the deep learning model
    2. Build, train, and test the deep learning model
    3. Process the deep learning outputs and generate the performance results.
# License and Referencing
This code package is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/). If you in any way use this code for research that results in publications, please cite our original article:

> A. Taha, M. Alrabeiah, and A. Alkhateeb, “[Enabling Large Intelligent Surfaces with Compressive Sensing and Deep Learning](https://arxiv.org/abs/1904.10136),” arXiv e-prints, p. arXiv:1904.10136, Apr 2019.
