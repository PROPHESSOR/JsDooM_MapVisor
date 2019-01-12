struct {
    SDL_Window      *window;
    SDL_Renderer    *renderer;
} Vi;

// Fake JSMB

void cls(void) {
    SDL_RenderClear(Vi.renderer);
}

void setColor(uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    SDL_SetRenderDrawColor(Vi.renderer, r, g, b, a);
}

void drawLine(int x1, int y1, int x2, int y2) {
    SDL_RenderDrawLine(Vi.renderer, x1, y1, x2, y2);
}

void drawPlot(int x, int y) {
    SDL_RenderDrawPoint(Vi.renderer, x, y);
}

void repaint(void) {
    SDL_RenderPresent(Vi.renderer);
}

// Functions

void initSDL(void) {
    if(SDL_Init(SDL_INIT_VIDEO)) {//EVERYTHING)) {
        error("Can't initialize SDL! Error: %s", SDL_GetError());
        exit(1);
    }

    log("SDL initialized successfully");

    Vi.window = SDL_CreateWindow(TITLE, 0, 0, SCW, SCH, SDL_WINDOW_SHOWN);

    if(Vi.window == NULL) {
        error("Can't create SDL window! Error: %s", SDL_GetError());
        exit(2);
    }

    log("SDL window created");

    Vi.renderer = SDL_CreateRenderer(Vi.window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

    if(Vi.renderer == NULL) {
        error("Can't create SDL renderer! Error: %s", SDL_GetError());
        exit(3);
    }
}

void render() {
    setColor(BGCOLOR);

    cls();

    setColor(HCOLOR);

    drawLine(SCW / 2, SCH / 2, vertexes[0].x * Layout.scale + Layout.offsetX, vertexes[0].y * Layout.scale + Layout.offsetY);

    if(Layout.showVertexes) {
        setColor(VCOLOR);

        for(uint16_t i = 0; i < vertexno; i++) {
            drawPlot(vertexes[i].x, vertexes[i].y);
        }
    }

    if(Layout.showLines) {
        setColor(LCOLOR);

        for(uint16_t i = 0; i < linedefno; i++) {
            drawLine(vertexes[linedefs[i].v1].x * Layout.scale + Layout.offsetX, vertexes[linedefs[i].v1].y * Layout.scale + Layout.offsetY, 
                     vertexes[linedefs[i].v2].x * Layout.scale + Layout.offsetX, vertexes[linedefs[i].v2].y * Layout.scale + Layout.offsetY);
        }
    }

    if(Layout.showNodes) {
        setColor(NCOLOR);

        for(uint16_t i = 0; i < nodeno; i++) {
            node_t *node = &nodes[i];

            drawLine(
                    node->lineX * Layout.scale + Layout.offsetX,
                    node->lineY * Layout.scale + Layout.offsetY,
                    (node->lineX + node->diffX) * Layout.scale + Layout.offsetX,
                    (node->lineY + node->diffY) * Layout.scale + Layout.offsetY
            );
        }
    }

    if(Layout.showBoxes) { // TODO:
        setColor(BCOLOR);
        
        for(uint16_t i = 0; i < nodeno; i++) {
            node_t *node = &nodes[i];

            // -
            drawLine(
                    (node->lineX - node->rbox.left) * Layout.scale + Layout.offsetX,
                    (node->lineY - node->rbox.top) * Layout.scale + Layout.offsetY,
                    (node->lineX + node->rbox.right) * Layout.scale + Layout.offsetX,
                    (node->lineY - node->rbox.top) * Layout.scale + Layout.offsetY
            );
        }
    }

    if(Layout.showSegs) {
        setColor(ECOLOR);

        for(uint16_t i = 0; i < segno; i++) {
            drawLine(vertexes[segs[i].v1].x * Layout.scale + Layout.offsetX, vertexes[segs[i].v1].y * Layout.scale + Layout.offsetY, 
                     vertexes[segs[i].v2].x * Layout.scale + Layout.offsetX, vertexes[segs[i].v2].y * Layout.scale + Layout.offsetY);
        }
    }

    repaint();
}
