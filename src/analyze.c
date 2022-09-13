#include <stdint.h>
#include <stdio.h>

#define MAX_SAMPLES 250000

size_t frekvenca[256];

int main()
{
    size_t samples = 0;
    size_t nicel = 0, enic = 0;
    size_t vsota = 0;

    for (int i = 0; i < MAX_SAMPLES; i++)
    {
        uint8_t byte = getchar();
        if (byte == EOF) break;

        printf("\r%d %%", i * 100 / MAX_SAMPLES);

        for (int j = 0; j < 8; j++)
        {
            uint8_t bit = (byte >> j) & 1;
            if (bit == 0)
                nicel++;
            else if (bit == 1)
                enic++;
        }

        vsota += byte;
        samples++;
        frekvenca[byte]++;
    }
    putchar('\n');

    printf("E(bit) = %lf, ", enic / (double) (nicel + enic));
    printf("E(byte) = %lf\n", vsota / (double) samples);
    
    FILE *f = fopen("results.csv", "w");

    fputs("število;frekvenca\n", f);
    for (int i = 0; i < 256; i++)
    {
        fprintf(f, "%d;%ld\n", i, frekvenca[i]);
    }

    fclose(f);

    return 0;
}
