//
// Structs
//

Colour :: struct {
    r, g, b, a: u8;
}

Rectangle :: struct {
    x: float;
    y: float;
    w: float;
    h: float;
}

Image :: struct {
    data:  *void;
    width:   s32;
    height:  s32;
    mipmaps: s32;
    format:  Pixel_Format;
}

Texture :: struct {
    id:      u32;
    width:   s32;
    height:  s32;
    mipmaps: s32;
    format:  Pixel_Format;
}

AudioStream :: struct {
    buffer:    *void;
    processor: *void;
    sampleRate: u32;
    sampleSize: u32;
    channels:   u32;
}

Sound :: struct {
    stream:     AudioStream;
    frameCount: u32;
}

Music :: struct {
    stream: AudioStream;
    frameCount: u32;
    looping: bool;
    ctxType : s32;
    ctxData: *void;
}

Wave :: struct {
    frameCount: u32;
    sampleRate: u32;
    sampleSize: u32;
    channels:   u32;
    data:       *void;
}

GlyphInfo :: struct {
    value:    s32;
    offsetX:  s32;
    offsetY:  s32;
    advanceX: s32;
    image:    Image;
}

Font :: struct {
    baseSize:     s32;
    glyphCount:   s32;
    glyphPadding: s32;
    texture:      Texture;
    recs:         *Rectangle;
    glyphs:       *GlyphInfo;
}

Camera :: struct {
    position:   Vector3;           // Camera position
    target:     Vector3;           // Camera target it looks-at
    up:         Vector3;           // Camera up vector (rotation over its axis)
    fovy:       float;             // Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
    projection: Camera_Projection; // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
}

Matrix :: struct {
    m0, m4, m8,  m12: float;
    m1, m5, m9,  m13: float;
    m2, m6, m10, m14: float;
    m3, m7, m11, m15: float;
}

Mesh :: struct {
    vertexCount: s32;        // Number of vertices stored in arrays
    triangleCount: s32;      // Number of triangles stored (indexed or not)

    // Vertex attributes data
    vertices: *float;        // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    texcoords: *float;       // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    texcoords2: *float;      // Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
    normals: *float;         // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
    tangents: *float;        // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
    colors: *u8;             // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    indices: *u16;           // Vertex indices (in case vertex data comes indexed)

    // Animation vertex data
    animVertices: *float;    // Animated vertex positions (after bones transformations)
    animNormals: *float;     // Animated normals (after bones transformations)
    boneIds: *u8;            // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning) (shader-location = 6)
    boneWeights: *float;     // Vertex bone weight, up to 4 bones influence by vertex (skinning) (shader-location = 7)
    boneMatrices: *Matrix;   // Bones animated transformation matrices
    boneCount: s32;          // Number of bones

    // OpenGL identifiers
    vaoId: u32;     // OpenGL Vertex Array Object id
    vboId: *u32;    // OpenGL Vertex Buffer Objects id (default vertex data)
}

Material :: struct {
    shader: Shader;     // Material shader
    maps: *MaterialMap; // Material maps array (MAX_MATERIAL_MAPS)
    params: [4]float;   // Material generic parameters (if required)
}

MaterialMap :: struct {
    texture: Texture;      // Material map texture
    colour: Colour;        // Material map color
    value: float;          // Material map value
}

Shader :: struct {
    id: u32;        // Shader program id
    locs: *s32;     // Shader locations array (RL_MAX_SHADER_LOCATIONS)
}

Transform :: struct {
    translation: Vector3;     // Translation
    rotation: Quaternion;     // Rotation
    scale: Vector3;           // Scale
}

BoneInfo :: struct {
    name: [32]u8;             // Bone name
    parent: s32;              // Bone parent
}

Model :: struct {
    transform: Matrix;        // Local transform matrix

    meshCount: s32;           // Number of meshes
    materialCount: s32;       // Number of materials
    meshes: *Mesh;            // Meshes array
    materials: *Material;     // Materials array
    meshMaterial: *s32;       // Mesh material number

    // Animation data
    boneCount: s32;           // Number of bones
    bones: *BoneInfo;         // Bones information (skeleton)
    bindPose: *Transform;     // Bones base transformation (pose)
}

Ray :: struct {
    position: Vector3;
    direction : Vector3;
}

RayCollision :: struct {
    hit: bool;
    distance: float;
    point: Vector3;
    normal: Vector3;
}

BoundingBox :: struct {
    min: Vector3;
    max: Vector3;
}

//
// Constants
//

WHITE :: Colour.{255, 255, 255, 255};

//
// Enums
//

Camera_Projection :: enum s32 {
    PERSPECTIVE  :: 0;
    ORTHOGRAPHIC :: 1;
}

Key :: enum s32 {
    SPACE       ::  32;
    MINUS       ::  45;
    ZERO        ::  48;
    ONE         ::  49;
    TWO         ::  50;
    THREE       ::  51;
    FOUR        ::  52;
    FIVE        ::  53;
    SIX         ::  54;
    SEVEN       ::  55;
    EIGHT       ::  56;
    NINE        ::  57;
    EQUAL       ::  61;
    A           ::  65;
    C           ::  67;
    D           ::  68;
    E           ::  69;
    J           ::  74;
    K           ::  75;
    L           ::  76;
    N           ::  78;
    P           ::  80;
    Q           ::  81;
    R           ::  82;
    S           ::  83;
    T           ::  84;
    U           ::  85;
    V           ::  86;
    W           ::  87;
    X           ::  88;
    GRAVE       ::  96;
    ENTER       :: 257;
    TAB         :: 258;
    BACKSPACE   :: 259;
    RIGHT       :: 262;
    LEFT        :: 263;
    DOWN        :: 264;
    UP          :: 265;
    HOME        :: 268;
    END         :: 269;
    F1          :: 290;
    F2          :: 291;
    F3          :: 292;
    LEFT_SHIFT  :: 340;
    LEFT_CTRL   :: 341;
    LEFT_ALT    :: 342;
    RIGHT_SHIFT :: 344;
}

Mouse_Button :: enum s32 {
    LEFT    :: 0;
    RIGHT   :: 1;
    MIDDLE  :: 2;
    SIDE    :: 3;
    EXTRA   :: 4;
    FORWARD :: 5;
    BACK    :: 6;
};

Texture_Filter :: enum s32 {
    POINT;
    BILINEAR;
    TRILINEAR;
    ANISOTROPIC_4X;
    ANISOTROPIC_8X;
    ANISOTROPIC_16X;
}

Config_Flags :: enum s32 {
    VSYNC_HINT               :: 0x00000040; // Set to try enabling V-Sync on GPU
    FULLSCREEN_MODE          :: 0x00000002; // Set to run program in fullscreen
    WINDOW_RESIZABLE         :: 0x00000004; // Set to allow resizable window
    WINDOW_UNDECORATED       :: 0x00000008; // Set to disable window decoration (frame and buttons)
    WINDOW_HIDDEN            :: 0x00000080; // Set to hide window
    WINDOW_MINIMIZED         :: 0x00000200; // Set to minimize window (iconify)
    WINDOW_MAXIMIZED         :: 0x00000400; // Set to maximize window (expanded to monitor)
    WINDOW_UNFOCUSED         :: 0x00000800; // Set to window non focused
    WINDOW_TOPMOST           :: 0x00001000; // Set to window always on top
    WINDOW_ALWAYS_RUN        :: 0x00000100; // Set to allow windows running while minimized
    WINDOW_TRANSPARENT       :: 0x00000010; // Set to allow transparent framebuffer
    WINDOW_HIGHDPI           :: 0x00002000; // Set to support HighDPI
    WINDOW_MOUSE_PASSTHROUGH :: 0x00004000; // Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
    BORDERLESS_WINDOWED_MODE :: 0x00008000; // Set to run program in borderless windowed mode
    MSAA_4X_HINT             :: 0x00000020; // Set to try enabling MSAA 4X
    INTERLACED_HINT          :: 0x00010000; // Set to try enabling interlaced video format (for V3D)
};

Material_Type :: enum s32 {
    ALBEDO     :: 0;   // Albedo material (same as: MATERIAL_MAP_DIFFUSE)
    DIFFUSE    :: 0;
    METALNESS  :: 1;   // Metalness material (same as: MATERIAL_MAP_SPECULAR)
    SPECULAR   :: 1;
    NORMAL     :: 2;   // Normal material
    ROUGHNESS  :: 3;   // Roughness material
    OCCLUSION  :: 4;   // Ambient occlusion material
    EMISSION   :: 5;   // Emission material
    HEIGHT     :: 6;   // Heightmap material
    CUBEMAP    :: 7;   // Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    IRRADIANCE :: 8;   // Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    PREFILTER  :: 9;   // Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    BRDF       :: 10;  // Brdf material
}

Pixel_Format :: enum s32 {
    UNCOMPRESSED_GRAYSCALE :: 1; // 8 bit per pixel (no alpha)
    UNCOMPRESSED_GRAY_ALPHA;     // 8*2 bpp (2 channels)
    UNCOMPRESSED_R5G6B5;         // 16 bpp
    UNCOMPRESSED_R8G8B8;         // 24 bpp
    UNCOMPRESSED_R5G5B5A1;       // 16 bpp (1 bit alpha)
    UNCOMPRESSED_R4G4B4A4;       // 16 bpp (4 bit alpha)
    UNCOMPRESSED_R8G8B8A8;       // 32 bpp
    UNCOMPRESSED_R32;            // 32 bpp (1 channel - float)
    UNCOMPRESSED_R32G32B32;      // 32*3 bpp (3 channels - float)
    UNCOMPRESSED_R32G32B32A32;   // 32*4 bpp (4 channels - float)
    UNCOMPRESSED_R16;            // 16 bpp (1 channel - half float)
    UNCOMPRESSED_R16G16B16;      // 16*3 bpp (3 channels - half float)
    UNCOMPRESSED_R16G16B16A16;   // 16*4 bpp (4 channels - half float)
    COMPRESSED_DXT1_RGB;         // 4 bpp (no alpha)
    COMPRESSED_DXT1_RGBA;        // 4 bpp (1 bit alpha)
    COMPRESSED_DXT3_RGBA;        // 8 bpp
    COMPRESSED_DXT5_RGBA;        // 8 bpp
    COMPRESSED_ETC1_RGB;         // 4 bpp
    COMPRESSED_ETC2_RGB;         // 4 bpp
    COMPRESSED_ETC2_EAC_RGBA;    // 8 bpp
    COMPRESSED_PVRT_RGB;         // 4 bpp
    COMPRESSED_PVRT_RGBA;        // 4 bpp
    COMPRESSED_ASTC_4x4_RGBA;    // 8 bpp
    COMPRESSED_ASTC_8x8_RGBA;    // 2 bpp
}

Trace_Log_Level :: enum s32 {
    ALL     :: 0; // Display all logs
    TRACE   :: 1; // Trace logging, intended for internal use only
    DEBUG   :: 2; // Debug logging, used for internal debugging, it should be disabled on release builds
    INFO    :: 3; // Info logging, used for program execution info
    WARNING :: 4; // Warning logging, used on recoverable failures
    ERROR   :: 5; // Error logging, used on unrecoverable failures
    FATAL   :: 6; // Fatal logging, used to abort program: exit(EXIT_FAILURE)
    NONE    :: 7; // Disable logging
}

//
// Bindings
//

#import "Math";

#if OS == .LINUX
{
    lm       :: #system_library,link_always "m";
    raylib   :: #library "raylib/lib/libraylib";
}
else #if OS == .WINDOWS
{
    winmm    :: #system_library,link_always "winmm";
    gdi32    :: #system_library,link_always "gdi32";
    user32   :: #system_library,link_always "user32";
    shell32  :: #system_library,link_always "shell32";
    raylib   :: #library "raylib/windows/raylib";
}
else #if OS == .ANDROID
{
    lm       :: #system_library,link_always "m";
    ldl      :: #system_library,link_always "dl";
    legl     :: #system_library,link_always "EGL";
    lglesv3  :: #system_library,link_always "GLESv3";
    landroid :: #system_library,link_always "android";
    raylib   :: #library "raylib/android/libraylib";
}

BeginDrawing :: () #foreign raylib;
BeginMode3D :: (camera: Camera) #foreign raylib;
CheckCollisionPointCircle :: (point: Vector2, centre: Vector2, radius: float) -> bool #foreign raylib;
CheckCollisionPointRec :: (point: Vector2, rect: Rectangle) -> bool #foreign raylib;
ClearBackground :: (colour: Colour) #foreign raylib;
ClearWindowState :: (flags: Config_Flags) #foreign raylib;
CloseWindow :: () #foreign raylib;
DrawCircleV :: (centre: Vector2, radius: float, colour := WHITE) #foreign raylib;
DrawCube :: (position: Vector3, width := 1.0, height := 1.0, length := 1.0, colour := WHITE) #foreign raylib;
DrawCubeWires :: (position: Vector3, width := 1.0, height := 1.0, length := 1.0, colour := WHITE) #foreign raylib;
DrawCylinderEx :: (start: Vector3, end: Vector3, start_radius: float, end_radius: float, sides: s32 = 30, colour := WHITE) #foreign raylib;
DrawFPS :: (x: s32, y: s32) #foreign raylib;
DrawLine3D :: (start: Vector3, end: Vector3, colour := WHITE) #foreign raylib;
DrawLineEx :: (start: Vector2, end: Vector2, thickness: float, colour := WHITE) #foreign raylib;
DrawMesh :: (mesh: Mesh, material: Material, transform: Matrix) #foreign raylib;
DrawMeshInstanced :: (mesh: Mesh, material: Material, transforms: *Matrix, transforms_count: s32) #foreign raylib;
DrawModel :: (model: Model, position: Vector3, scale := 1.0, tint := WHITE) #foreign raylib;
DrawModelEx :: (model: Model, position: Vector3, rotationAxis := Vector3.{0, 1, 0}, rotationAngle := 0.0, scale := Vector3.{1, 1, 1}, tint := WHITE) #foreign raylib;
DrawRay :: (ray: Ray, colour := WHITE) #foreign raylib;
DrawRectangle :: (x: s32, y: s32, width: s32, height: s32, colour: Colour) #foreign raylib;
DrawRectangleRec :: (rect: Rectangle, colour := WHITE) #foreign raylib;
DrawText :: (text: *u8, x: s32, y: s32, size: s32, colour := WHITE) #foreign raylib;
DrawTextEx :: (font: Font, text: *u8, pos: Vector2, size: float, spacing: float = 0, tint := WHITE) #foreign raylib;
DrawTexture :: (texture: Texture, x: s32, y: s32, tint: Colour = WHITE) #foreign raylib;
DrawTextureEx :: (texture: Texture, position: Vector2, rotation: float, scale: float, tint := WHITE) #foreign raylib;
DrawTexturePro :: (texture: Texture, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: float, tint := WHITE) #foreign raylib;
EndDrawing :: () #foreign raylib;
EndMode3D :: () #foreign raylib;
GenImageColor :: (width: s32, height: s32, colour := WHITE) -> Image #foreign raylib;
GenMeshCube :: (width: float, height: float, length: float) -> Mesh #foreign raylib;
GenTextureMipmaps :: (texture: *Texture) #foreign raylib;
GetCurrentMonitor :: () -> s32 #foreign raylib;
GetFrameTime :: () -> float #foreign raylib;
GetKeyPressed :: () -> s32 #foreign raylib;
GetMonitorRefreshRate :: (monitor: s32) -> s32 #foreign raylib;
GetMousePosition :: () -> Vector2 #foreign raylib;
GetRayCollisionBox :: (ray: Ray, box: BoundingBox) -> RayCollision #foreign raylib;
GetRayCollisionMesh :: (ray: Ray, mesh: Mesh, transform: Matrix) -> RayCollision #foreign raylib;
GetRenderHeight :: () -> s32 #foreign raylib;
GetRenderWidth :: () -> s32 #foreign raylib;
GetScreenHeight :: () -> s32 #foreign raylib;
GetScreenToWorldRay :: (position: Vector2, camera: Camera) -> Ray #foreign raylib;
GetScreenWidth :: () -> s32 #foreign raylib;
GetTime :: () -> float64 #foreign raylib;
ImageFlipVertical :: (image: *Image) #foreign raylib;
ImageFormat :: (image: *Image, format: Pixel_Format) #foreign raylib;
ImageMipmaps :: (image: *Image) #foreign raylib;
InitAudioDevice :: () #foreign raylib;
InitWindow :: (width: s32, height: s32, title: *u8) #foreign raylib;
IsKeyDown :: (key: Key) -> bool #foreign raylib;
IsKeyPressed :: (key: Key) -> bool #foreign raylib;
IsMaterialValid :: (material: Material) -> bool #foreign raylib;
IsMouseButtonDown :: (button: Mouse_Button) -> bool #foreign raylib;
IsMouseButtonPressed :: (button: Mouse_Button) -> bool #foreign raylib;
IsMouseButtonReleased :: (button: Mouse_Button) -> bool #foreign raylib;
IsMouseButtonUp :: (button: Mouse_Button) -> bool #foreign raylib;
LoadFileData :: (file: *u8, bytes_read: *s32) -> *u8 #foreign raylib;
LoadFontFromMemory :: (type: *u8, data: *u8, byte_count: s32, font_size: s32, codepoints: *s32, codepoint_count: s32) -> Font #foreign raylib;
LoadImage:: (file: *u8) -> Image #foreign raylib;
LoadImageFromMemory :: (type: *u8, data: *u8, size: s32) -> Image #foreign raylib;
LoadMaterialDefault :: () -> Material #foreign raylib;
LoadModel :: (file: *u8) -> Model #foreign raylib;
LoadModelFromMesh:: (mesh: Mesh) -> Model #foreign raylib;
LoadMusicStreamFromMemory :: (type: *u8, data: *u8, size: s32) -> Music #foreign raylib;
LoadSoundFromWave :: (wave: Wave) -> Sound #foreign raylib;
LoadTexture :: (file: *u8) -> Texture #foreign raylib;
LoadTextureFromImage :: (image: Image) -> Texture #foreign raylib;
LoadWaveFromMemory :: (type: *u8, data: *u8, size: s32) -> Wave #foreign raylib;
MeasureText :: (text: *u8, size: s32) -> s32 #foreign raylib;
MeasureTextEx :: (font: Font, text: *u8, size: float, spacing: float = 0) -> Vector2 #foreign raylib;
PauseMusicStream :: (music: Music) #foreign raylib;
PauseSound :: (sound: Sound) #foreign raylib;
PlayMusicStream :: (music: Music) #foreign raylib;
PlaySound :: (sound: Sound) #foreign raylib;
ResumeMusicStream :: (music: Music) #foreign raylib;
ResumeSound :: (sound: Sound) #foreign raylib;
SaveFileData :: (file: *u8, data: *u8, byte_count: s32) -> bool #foreign raylib;
SetConfigFlags :: (flags: Config_Flags) #foreign raylib;
SetMaterialTexture :: (material: *Material, type: Material_Type, texture: Texture) #foreign raylib;
SetModelMeshMaterial :: (model: *Model, meshId: s32, materialId: s32) #foreign raylib;
SetMusicVolume :: (music: Music, volume: float) #foreign raylib;
SetSoundVolume :: (sound: Sound, volume: float) #foreign raylib;
SetTargetFPS :: (fps: s32) #foreign raylib;
SetTextureFilter :: (texture: Texture, filter: Texture_Filter) #foreign raylib;
SetWindowIcon :: (image: Image) #foreign raylib;
SetWindowSize :: (width: s32, height: s32) #foreign raylib;
TakeScreenshot :: (filename: *u8) #foreign raylib;
UnloadImage :: (image: Image) #foreign raylib;
UnloadMaterial :: (material: Material) #foreign raylib;
UnloadWave :: (wave: Wave) #foreign raylib;
UpdateCamera :: (camera: *Camera, mode: s32) #foreign raylib;
UpdateMusicStream :: (music: Music) #foreign raylib;
UpdateTexture :: (texture: Texture, pixels: *void) #foreign raylib;
WindowShouldClose :: () -> bool #foreign raylib;
SetTraceLogLevel :: (level: Trace_Log_Level) #foreign raylib;