typedef struct vertex_t {
    int16_t x;
    int16_t y;
} vertex_t;

typedef struct linedef_t {
    uint16_t v1;
    uint16_t v2;
    uint16_t flags;
    uint16_t action;
    uint16_t sectortag;
    uint16_t front;
    uint16_t back;
} linedef_t;

typedef struct sidedef_t {
    int16_t offset_x;
    int16_t offset_y;
    char texture_upper[8];
    char texture_lower[8];
    char texture_middle[8];
    uint16_t sector;
} sidedef_t;

typedef struct sector_t {
    int16_t floor;
    int16_t ceil;
    char texture_floor[8];
    char texture_ceil[8];
    int16_t brightness;
    uint16_t special;
    uint16_t tag;
} sector_t;

struct Box {
    int16_t top;
    int16_t bottom;
    int16_t left;
    int16_t right;
};

typedef struct {
    int16_t lineX;
    int16_t lineY;
    int16_t diffX;
    int16_t diffY;
    struct Box     rbox;
    struct Box     lbox;
    uint16_t rchild;
    uint16_t lchild;
} node_t;

typedef struct {
    uint16_t v1;
    uint16_t v2;
    int16_t  angle;
    uint16_t linedef;
    int16_t  side;
    int16_t  offset;
} seg_t;


static vertex_t     *vertexes   = NULL;
static uint16_t      vertexno   = 0;
static linedef_t    *linedefs   = NULL;
static uint16_t      linedefno  = 0;
static sidedef_t    *sidedefs   = NULL;
static uint16_t      sidedefno  = 0;
static sector_t     *sectors    = NULL;
static uint16_t      sectorno   = 0;
static node_t       *nodes      = NULL;
static uint16_t      nodeno     = 0;
static seg_t        *segs       = NULL;
static uint16_t      segno      = 0;

_Noreturn
void fileOpenError(const char filename[]) {
    error("\n\n[FILE ERROR]: Can't open file \"%s!\"!\n\n", filename);
    exit(4);
}

int readmap(const char *path) {
    printf("Doom Map Viewer\n");

    /**/ FILE *file = fopen("data/VERTEXES.lmp", "r");
    if(!file) fileOpenError("data/VERTEXES.lmp");
    fseek(file, 0, SEEK_END); // Getting file size in bytes using fseek(end) and ftell
    vertexno = (uint16_t)((uint32_t) ftell(file) / sizeof(vertex_t));
    printf("Found %hu vertices\n", vertexno);

    fseek(file, 0, SEEK_SET);
    vertexes = (vertex_t *) malloc(vertexno * sizeof(vertex_t));

    fread(vertexes, sizeof(vertex_t), vertexno, file);
#ifdef DEBUG_STRUCTS
    for(short i = 0; i < vertexno; i++) {
        printf("Vertex(%hi; %hi)\n", vertexes[i].x, vertexes[i].y);
    }
#endif
    /**/ fclose(file);

    /*      */ file = fopen("data/LINEDEFS.lmp", "r");
    if(!file) fileOpenError("data/LINEDEFS.lmp");
    fseek(file, 0, SEEK_END); // Getting file size in bytes using fseek(end) and ftell
    linedefno = (uint16_t)((uint32_t) ftell(file) / sizeof(linedef_t));
    printf("Found %hu linedefs\n", linedefno);

    fseek(file, 0, SEEK_SET);
    linedefs = (linedef_t *) malloc(linedefno * sizeof(linedef_t));

    fread(linedefs, sizeof(linedef_t), linedefno, file);
#ifdef DEBUG_STRUCTS
    for(short i = 0; i < linedefno; i++) {
        printf("Linedef(%hi; %hi)\n", linedefs[i].v1, linedefs[i].v2);
    }
#endif
    /**/ fclose(file);

    /*      */ file = fopen("data/SIDEDEFS.lmp", "r");
    if(!file) fileOpenError("data/SIDEDEFS.lmp");
    fseek(file, 0, SEEK_END); // Getting file size in bytes using fseek(end) and ftell
    sidedefno = (uint16_t)((uint32_t) ftell(file) / sizeof(sidedef_t));
    printf("Found %hu sidedefs\n", sidedefno);

    fseek(file, 0, SEEK_SET);
    sidedefs = (sidedef_t *) malloc(sidedefno * sizeof(sidedef_t));

    fread(sidedefs, sizeof(sidedef_t), sidedefno, file);
#ifdef DEBUG_STRUCTS
    for(short i = 0; i < sidedefno; i++) {
        printf("Sidedef(%hi)\n", sidedefs[i].sector);
    }
#endif
    /**/ fclose(file);

    /*      */ file = fopen("data/SECTORS.lmp", "r");
    if(!file) fileOpenError("data/SECTORS.lmp");
    fseek(file, 0, SEEK_END); // Getting file size in bytes using fseek(end) and ftell
    sectorno = (uint16_t)((uint32_t) ftell(file) / sizeof(sector_t));
    printf("Found %hu sectors\n", sectorno);

    fseek(file, 0, SEEK_SET);
    sectors = (sector_t *) malloc(sectorno * sizeof(sector_t));

    fread(sectors, sizeof(sector_t), sectorno, file);
#ifdef DEBUG_STRUCTS
    for(short i = 0; i < sectorno; i++) {
        printf("Sector(%hi; %hi)\n", sectors[i].floor, sectors[i].ceil);
    }
#endif
    /**/ fclose(file);

    /*      */ file = fopen("data/NODES.lmp", "r");
    if(!file) fileOpenError("data/NODES.lmp");
    fseek(file, 0, SEEK_END); // Getting file size in bytes using fseek(end) and ftell
    nodeno = (uint16_t)((uint32_t) ftell(file) / sizeof(node_t));
    printf("Found %hu nodes\n", nodeno);

    fseek(file, 0, SEEK_SET);
    nodes = (node_t *) malloc(nodeno * sizeof(node_t));

    fread(nodes, sizeof(node_t), nodeno, file);
#ifdef DEBUG_STRUCTS
    for(short i = 0; i < nodeno; i++) {
        printf("Node(%hi; %hi, %hi; %hi, Right child: %hu; Left child: %hu)\n", nodes[i].lineX, nodes[i].lineY, nodes[i].diffX, nodes[i].diffY, nodes[i].rchild, nodes[i].lchild);
    }
#endif
    /**/ fclose(file);

    /*      */ file = fopen("data/SEGS.lmp", "r");
    if(!file) fileOpenError("data/SEGS.lmp");
    fseek(file, 0, SEEK_END); // Getting file size in bytes using fseek(end) and ftell
    segno = (uint16_t)((uint32_t) ftell(file) / sizeof(seg_t));
    printf("Found %hu SEGs\n", segno);

    fseek(file, 0, SEEK_SET);
    segs = (seg_t *) malloc(segno * sizeof(seg_t));

    fread(segs, sizeof(seg_t), segno, file);
#ifdef DEBUG_STRUCTS
    for(short i = 0; i < segno; i++) {
        printf("SEG(%hi; %hi, %hi° %hi <%hi> ±%hi)\n", segs[i].v1, segs[i].v2, segs[i].angle, segs[i].linedef, segs[i].side, segs[i].offset);
    }
#endif
    /**/ fclose(file);
}
