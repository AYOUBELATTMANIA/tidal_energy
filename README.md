# Tidenergy : A set of MATLAB functions for the computation and plotting of tidal energy potential in user-specified regions using FES2014b model 

# Fuction to transform the model nc files into a single .mat structure 

> fes2014_nc_to_mat (path)

# Fuction to extract the model tidal harmonic amplitudes and phases

> extract_fes_data(matfile)

# Fuction to compute tidal energy 

> compute_tide_energy (data_k1,data_k2,data_m2,data_n2,data_o1,data_s2,start_date,end_date)

# Example

>%% add main directory

>clear all; close all;clc;
>selpath = uigetdir('','Add path');
>addpath(genpath(selpath))
>sprintf('%s direcoty has been added successfully', selpath)
>%% convert nc files to mat file
>%%% this done only once a time
>% path=pwd; fes2014_nc_to_mat (path); 
>%% define and plot region limits 
>global lon_min lon_max lat_min lat_max
>lon_min=-7; 
>lon_max=-3.5; 
>lat_min=35; 
>lat_max=36;  
>figure
>geobasemap ('streets')
>geoplot([lat_min lat_max lat_max lat_min lat_min],...
>        [lon_min lon_min lon_max lon_max lon_min],'--b','linewidth',2);
>%% load fes model mat file
>FES= matfile('FES_M2_S2_N2_k2_K1_O1.mat'); 
>%% extract fes data and save txt files
>extract_fes_data(FES)
>%% load txt files
>A=load('fes_onde_K1.txt');B=load('fes_onde_K2.txt');C=load('fes_onde_M2.txt');
>D=load('fes_onde_N2.txt');E=load('fes_onde_O1.txt');F=load('fes_onde_S2.txt');
>%% compute tide energy and save txt file
>[longitude,latitude,energy]=compute_tide_energy (A,B,C,D,E,F,'01-01-2025','31-12-2025');
>%% plot tide energy
>plot_tide_energy(latitude,longitude,energy)
