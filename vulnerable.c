https://www.instagram.com/katya________katya____/?utm_source=ig_web_button_share_sheet
555555

#include <stdio.h>

int main(void)
{
    char buffer[32];  // Small buffer for overflow demonstration

    printf("Enter some text:\n");
    gets(buffer);  /* unsafe: no length check */

    printf("You entered: %s\n", buffer);
    return 0;
}