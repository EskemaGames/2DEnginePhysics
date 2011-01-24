//
//  Common.h
//  
//
//  Created by Eskema on 02/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



#pragma mark -
#pragma mark Macros

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((arc4random() / (float)0x3fffffff )-1.0f)

// Macro which returns a random number between 0 and 1
#define RANDOM_0_TO_1() ((arc4random() / (float)0x7fffffff ))

// Macro which converts degrees into radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) 

// Macro that allows you to clamp a value within the defined bounds
#define CLAMP(X, A, B) ((X < A) ? A : ((X > B) ? B : X))

#define RANDOM_FLOAT_BETWEEN(x, y) (((float) rand() / RAND_MAX) * (y - x) + x)

//get a random number between min and max
//return rand() % (max - min) + min;
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + arc4random() % ((__MAX__+1) - (__MIN__)))




#pragma mark -
#pragma mark Types

typedef struct MyFonts
{
	int posX;
	int posY;
	int w;
	int h;
	int offsetx;
	int offsety;
	int xadvance;
}_ArrayFonts;


typedef struct MySprite
{
	int posX;
	int posY;
	int w;
	int h;
	int frame;
	int cachedFrameNum;
	int speed;
}_AnimationSprite;

typedef struct _TileVert {
	short v[2];
	float uv[2];
	unsigned color;
} TileVert;

typedef struct _Color4f {
	float red;
	float green;
	float blue;
	float alpha;
} Color4f;

typedef struct _Vector2f {
	float x;
	float y;
} Vector2f;


typedef struct _Quad2f {
	float bl_x, bl_y;
	float br_x, br_y;
	float tl_x, tl_y;
	float tr_x, tr_y;
} Quad2f;



// Structure that holds the location and size for each point sprite
typedef struct {
	float x;
	float y;
	float size;
	Color4f color;
} PointSprite;

// Structure used to hold particle specific information
typedef struct {
	Vector2f position;
	Vector2f direction;
    Vector2f startPos;
	Color4f color;
	Color4f deltaColor;
    float radialAcceleration;
    float tangentialAcceleration;
	float radius;
	float radiusDelta;
	float angle;
	float degreesPerSecond;
	float particleSize;
	float particleSizeDelta;
	float timeToLive;
} Particle;


#pragma mark -
#pragma mark Inline Functions

static const Vector2f Vector2fZero = {0.0f, 0.0f};

static const Vector2f Vector2fInit = {1.0f, 1.0f};

static inline Vector2f Vector2fMake(float x, float y)
{
	return (Vector2f) {x, y};
}

static const Color4f Color4fInit = {255.0f, 255.0f, 255.0f, 1.0f};

static inline Color4f Color4fMake(float red, float green, float blue, float alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, float s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline float Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (float) v1.x * v2.x + v1.y * v2.y;
}

static inline float Vector2fLength(Vector2f v)
{
	return (float) sqrtf(Vector2fDot(v, v));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}







