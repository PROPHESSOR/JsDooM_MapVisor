#include "stdio.h"
#include "SDL2/SDL.h"

#define SCW     640
#define SCH     480
#define TITLE   "Viewer"
#define BGCOLOR 0, 0, 0, 255    // Background color
#define FGCOLOR 255, 0, 0,255   // Lines color
#define HGCOLOR 0, 0, 255, 255  // Helper line color
#define STEP    15

#define true  1 // 0 =D
#define false 0 // 1 =D

#define error(fmt, args...)  printf("[ERROR] "  fmt " %s:%d=>%s(...)\n", ##args, __FILE__, __LINE__, __func__)
#define warn(fmt, args...)   printf("[WARN] "   fmt "\n", ##args)
#define log(fmt, args...)    printf("[LOG] "    fmt "\n", ##args)

struct {
    int   offsetX;
    int   offsetY;
    float scale;
} Layout;


#include "doommap.c"
#include "renderer.c"

int main() {
    log("Starting...");

    Layout.offsetX = 0;
    Layout.offsetY = 0;
    Layout.scale   = 1.f;

    initSDL();
    readmap("");

    SDL_Event event;

    render();

    while(true){
        SDL_WaitEvent(&event);

        switch(event.type) {
            case SDL_QUIT:
                return 0;
            case SDL_KEYDOWN:
                switch(event.key.keysym.sym) {
                    case SDLK_UP:
                        Layout.offsetY -= STEP;
                        break;
                    case SDLK_DOWN:
                        Layout.offsetY += STEP;
                        break;
                    case SDLK_LEFT:
                        Layout.offsetX -= STEP;
                        break;
                    case SDLK_RIGHT:
                        Layout.offsetX += STEP;
                        break;
                    case SDLK_KP_PLUS:
                        Layout.scale   += Layout.scale / 2.f;
                        break;
                    case SDLK_KP_MINUS:
                        Layout.scale   -= Layout.scale / 2.f;
                        break;
                }

                render();
                break;
        }

    }

    return 0;
}

