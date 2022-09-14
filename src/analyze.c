#include <stdint.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <math.h>
#include <limits.h>

#define MAX_SAMPLES 1000000 // milijon

#define clear() printf("\033[2J\033[1;1H")

size_t frekvenca[UINT8_MAX];
uint8_t samples[MAX_SAMPLES];

int prev_bars = -1;
int prev_percent = -1;
int prev_width = -1;

void print_progress(float progress)
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    int window_width = w.ws_col;

    int width   = window_width - 8;
    int bars    = fmax(round(progress * width), 0);
    int spaces  = width - bars;
    int percent = round(progress * 100);
    
    if (bars != prev_bars || percent != prev_percent || window_width != prev_width)
    {
        if (window_width < prev_width) clear();
        printf("\r[");
        for (int i = 0; i < bars-1; i++) putchar('=');
        
        if (bars == width) putchar('=');
        else if (bars > 0) putchar('>');
        
        for (int i = 0; i < spaces; i++) putchar(' ');
        printf("] %3d %%", percent);
        fflush(stdout);
    }
    
    prev_bars = bars;
    prev_percent = percent;
    prev_width = window_width;
}

float a, b;
uint32_t number;
int offset = 0;
int i_num = 0;
size_t count = 0;
size_t ncoords = 0;

void calc_pi(uint8_t rand_byte)
{
    // iz 8-bitnih števil sestavi 32-bitno
    number = (number << offset) | rand_byte;
    
    if (offset == 24) 
    {
        if (i_num == 0)
            a = number / (float) UINT32_MAX;
        else
            b = number / (float) UINT32_MAX;
        
        if (i_num == 1)
        {
            // je znotraj kroga?
            if (a*a + b*b < 1.0f) {
                count++;
            }
            ncoords++;
        }
        
        i_num = (i_num + 1) % 2;
    }
    
    offset = (offset + 8) % 32;
}

int main()
{
    size_t nsamples = 0;
    size_t nicel = 0, enic = 0;
    size_t vsota = 0;

    clear();

    for (int i = 0; i < MAX_SAMPLES; i++)
    {
        int byte = getchar();
        if (byte == EOF) break;

        float progress = i / (float) MAX_SAMPLES;
        print_progress(progress);

        for (int j = 0; j < 8; j++)
        {
            uint8_t bit = (byte >> j) & 1;
            if (bit == 0)
                nicel++;
            else if (bit == 1)
                enic++;
        }
        
        samples[i] = byte;
        calc_pi(byte);

        vsota += byte;
        nsamples++;
        frekvenca[byte]++;
    }
    
    fclose(stdin);

    double E_bit  = enic  / (double) (nicel + enic);
    double E_byte = vsota / (double) nsamples;

    // standardni odklon
    double sum = 0;
    for (int i = 0; i < nsamples; i++)
    {
        double diff = samples[i] - E_byte;
        sum += diff * diff;
    }
    double sN_byte = sqrt(sum / nsamples);

    sum = 0;
    for (int i = 0; i < nicel; i++)
    {
        double diff = 0 - E_bit;
        sum += diff * diff;
    }
    for (int i = 0; i < enic; i++)
    {
        double diff = 1 - E_bit;
        sum += diff * diff;
    }
    double sN_bit = sqrt(sum / (enic + nicel));


    double pi = (double) count / ncoords * 4;

    printf("E(bit)  = %4.3lf, ",    E_bit);
    printf("E(byte)  = %7.3lf\n\r", E_byte);
    printf("sN(bit) = %4.3lf, ",    sN_bit);
    printf("sN(byte) = %7.3lf\n\r", sN_byte);
    printf("pi = %lf\n\r\n\r", pi);

    printf("Frekvence shranjene v 'results.csv'\n\r");

    FILE *csv = fopen("results.csv", "w");

    fputs("število;frekvenca\n", csv);
    for (int i = 0; i < UINT8_MAX; i++)
    {
        fprintf(csv, "%d;%ld\n", i, frekvenca[i]);
    }

    fclose(csv);

    return 0;
}
