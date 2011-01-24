
//animations flag
#define END_ANIMATION -1

//set the game in landscape or not
#define LANDSCAPE 1

//to display fps if we want
#define FPS 1


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 16





//type of bodies available in box2d by default
typedef enum {
	BOX,
	CIRCLE
}bodyTpes;


//we work with states, so each animation has its own state
//this way we can change from one state to another, and keep 
//track of actual state
//of course you need to create your states, to fit your game needs
typedef enum {
	MOVELEFT = 0,
    MOVERIGHT,
	MOVEUP,
	MOVEDOWN,
    STOPPED,
    ATTACK,
	DEAD,
	DYING,
	CREATING,
	_TOTALSTATES
}state;




//these are our default values for the statemanager
//of course we change theses values to fit 
//our game requeriments
typedef enum
{
	MENU,
	PLAY,
	PLAYNOPHYSICS
}options;
