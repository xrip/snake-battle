/* Main translation unit; original image entry 03EF:0003. */
extern int game_quit;
extern char resource_names[];
void f_0c85_1009(void);
void f_0c85_01a2(void *, int);
void f_0c85_0449(void);
void f_044d_2333(void);
void f_0c85_10ee(void);

void main(void)
{
    game_quit = 0;
    f_0c85_1009();
    f_0c85_01a2(resource_names, 84);
    f_0c85_0449();
    f_044d_2333();
    f_0c85_10ee();
}
