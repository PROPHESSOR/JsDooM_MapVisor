#include "stdio.h"
#include "SDL2/SDL.h"

#define SCW     640
#define SCH     480
#define TITLE   "Viewer"
#define BGCOLOR 0, 0, 0, 255       // Background color
#define LCOLOR  255, 0, 0,255      // Lines color
#define HCOLOR  0, 0, 255, 255     // Helper line color
#define NCOLOR  255, 255, 0, 255   // Nodes color
#define VCOLOR  0, 255, 0, 255     // Vertices color
#define BCOLOR  0, 128, 0, 255     // BSP boxes color
#define ECOLOR  0, 255, 255, 255   // SEGs color
#define STEP    15

typedef enum { false = 0, true = 1 } bool;

#define error(fmt, args...)  printf("[ERROR] "  fmt " %s:%d=>%s(...)\n", ##args, __FILE__, __LINE__, __func__)
#define warn(fmt, args...)   printf("[WARN] "   fmt "\n", ##args)
#define log(fmt, args...)    printf("[LOG] "    fmt "\n", ##args)

struct {
    int   offsetX;
    int   offsetY;
    float scale;
    bool  showNodes;
    bool  showLines;
    bool  showVertexes;
    bool  showBoxes;
    bool  showSegs;
} Layout;



#include "doommap.c"
#include "renderer.c"

int main() {
    printf("Viewer (c) PROPHESSOR 2019\n");
    printf(
            "=== Controls ===\n"
            "\tUp arrow\t- Move top\n"
            "\tDown arrow\t- Move bottom\n"
            "\tLeft arrow\t- Move left\n"
            "\tRight arrow\t- Move right\n"
            "\tKP+\t\t- Zoom in\n"
            "\tKP-\t\t- Zoom out\n"
            "\tL\t\t- Show lines\n"
            "\tN\t\t- Show nodes\n"
            "\tV\t\t- Show vertices\n"
            "\tB\t\t- Show BSP boxes\n"
            "\tE\t\t- Show SEGs\n"
    );

    Layout.offsetX      = 0;
    Layout.offsetY      = 0;
    Layout.scale        = 1.f;
    Layout.showNodes    = false;
    Layout.showLines    = true;
    Layout.showVertexes = false;
    Layout.showBoxes    = false;
    Layout.showSegs     = false;

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
                    case SDLK_n:
                        Layout.showNodes = !Layout.showNodes;
                        break;
                    case SDLK_l:
                        Layout.showLines = !Layout.showLines;
                        break;
                    case SDLK_v:
                        Layout.showVertexes = !Layout.showVertexes;
                        break;
                    case SDLK_b:
                        Layout.showBoxes = !Layout.showBoxes;
                        break;
                    case SDLK_e:
                        Layout.showSegs = !Layout.showSegs;
                        break;
                }

                render();
                break;
        }

    }

    return 0;
}

