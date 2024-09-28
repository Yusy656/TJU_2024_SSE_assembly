#include <stdio.h>

int main(){
    int Out = 'a';

    for (int i = 0; i < 2; i++){
        for (int j = 0; j < 13; j++){
            printf("%c", Out);
            Out++;
        }
        printf("\n");
    }

    return 0;
}