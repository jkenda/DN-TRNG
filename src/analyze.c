#include <stdint.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <math.h>
#include <limits.h>

#define MAX_SAMPLES 1000000 // milijon


size_t frekvenca[UINT8_MAX];
int prev_bars = -1;
int prev_percent = -1;
int prev_width = -1;

void print_progress(float progress)
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    int window_width = w.ws_col;

    int width   = window_width - 9;
    int bars    = fmax(round(progress * width), 0);
    int spaces  = width - bars;
    int percent = round(progress * 100);
    
    if (bars != prev_bars || percent != prev_percent || window_width != prev_width)
    {
        printf("\r[");
        for (int i = 0; i < bars; i++) putchar('=');
        
        if (bars > 0 && bars < width) putchar('>');
        else if (bars == width) putchar('=');
        else putchar(' ');
        
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
    size_t samples = 0;
    size_t nicel = 0, enic = 0;
    size_t vsota = 0;

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
        
        calc_pi(byte);

        vsota += byte;
        samples++;
        frekvenca[byte]++;
    }

    fclose(stdin);

    double pi = (double) count / ncoords * 4;

    printf("E(bit) = %lf, ", enic / (double) (nicel + enic));
    printf("E(byte) = %lf, ", vsota / (double) samples);
    printf("pi = %lf\n", pi);

    printf("Saved info to results.csv\n");

    FILE *csv = fopen("results.csv", "w");

    fputs("število;frekvenca\n", csv);
    for (int i = 0; i < UINT8_MAX; i++)
    {
        fprintf(csv, "%d;%ld\n", i, frekvenca[i]);
    }

    fclose(csv);

    return 0;
}
