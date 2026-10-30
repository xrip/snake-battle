/* Recovered C for the original 0729 game module. Addresses and proof are in
   bindings.json/check.py. Source contains no embedded executable bytes. */
#include <string.h>
#include <dos.h>
#include "GAME.H"

void game_000d(Card *card)
{
    int x,y;
    Card temporary;
    temporary.group=card->group;
    temporary.anchor_y=card->anchor_y;
    temporary.anchor_x=6-card->anchor_x;
    for(x=0;x<7;++x)
        for(y=0;y<7;++y)
            temporary.cell[x][y]=card->cell[6-x][y];
    memcpy(card,&temporary,sizeof(Card));
}

void game_00b4(Card *card)
{
    int x,y;
    Card temporary;
    temporary.group=card->group;
    temporary.anchor_x=6-card->anchor_y;
    temporary.anchor_y=card->anchor_x;
    for(x=0;x<7;++x)
        for(y=0;y<7;++y)
            temporary.cell[6-x][y]=card->cell[y][x];
    memcpy(card,&temporary,sizeof(Card));
}

void game_015b(void)
{
    int slot,card,rotation;
    Profile *profile;
    if(!g_40ff) {
        g_1b3c=f_0b33_002a(0xab00);
        for(slot=0;slot<4;++slot) {
            if((profile=g_34d7[slot])!=0) {
                for(card=0;card<profile->card_count;++card) {
                    for(rotation=0;rotation<=3;++rotation) {
                        if(rotation==0) {
                            memcpy(&g_1b3c[slot][0][0][card],&profile->cards[card],sizeof(Card));
                            memcpy(&g_1b3c[slot][0][1][card],&profile->cards[card],sizeof(Card));
                            game_000d(&g_1b3c[slot][0][1][card]);
                        } else {
                            memcpy(&g_1b3c[slot][rotation][0][card],&g_1b3c[slot][rotation-1][0][card],sizeof(Card));
                            game_00b4(&g_1b3c[slot][rotation][0][card]);
                            memcpy(&g_1b3c[slot][rotation][1][card],&g_1b3c[slot][rotation-1][1][card],sizeof(Card));
                            game_00b4(&g_1b3c[slot][rotation][1][card]);
                        }
                    }
                }
            }
        }
    }
}

void game_03c7(void)
{
    if(!g_40ff) f_0b33_0063(g_1b3c);
}

void game_03de(int slot)
{
    if(g_34d3) {
        f_0c85_0467(2);
        f_0c85_0ead(g_03ec[slot].x0,g_03ec[slot].y0,g_03ec[slot].x1,g_03ec[slot].y1,g_40bc,0);
        f_0c85_05a5(g_40bc,g_03ec[slot].x0,g_03ec[slot].y0-1,g_3171[slot].score);
        f_0c85_0467(1);
    }
}

void game_046e(void)
{
    int slot;
    Snake *snake;
    ++g_340d;
    for(slot=0;slot<4;++slot)
        if(g_34d7[slot]) {
            snake=&g_3171[slot];
            f_0e92_0381(&snake->score,2);
            game_03de(slot);
        }
}

void game_04cc(void)
{
    int slot;
    Snake *snake;
    for(slot=0;slot<4;++slot)
        if(g_34d7[slot]) {
            snake=&g_3171[slot];
            f_0e92_02f3(&snake->score,2);
        }
}

int game_051e(void)
{
    char token;
    while(1) {
        f_0e92_020a(&token,1);
        g_1b40=token;
        if(token==14) {
            game_046e();
            return 2;
        }
        if(token==13) return 4;
    }
}

void game_055b(Card *card,int direction,int reflected)
{
    Cell *old,*next;
    int x,y;
    Card temporary;
    memcpy(&temporary,card,sizeof(Card));
    if(reflected) game_000d(&temporary);
    switch(direction) {
    case 3: game_00b4(&temporary);
    case 2: game_00b4(&temporary);
    case 1: game_00b4(&temporary); break;
    case 0: break;
    }
    next=&temporary.cell[temporary.anchor_x][temporary.anchor_y];
    if(g_40ff) next->symbol=9;
    else switch(direction) {
    case 3: next->symbol=13; break;
    case 2: next->symbol=12; break;
    case 1: next->symbol=11; break;
    case 0: break;
    }
    old=&g_3415.cell[0][0];
    next=&temporary.cell[0][0];
    if(g_3415.group!=temporary.group) {
        f_0a0b_0306(491,256,temporary.group);
        g_3415.group=temporary.group;
    }
    for(y=0;y<7;++y)
        for(x=0;x<7;++x) {
            if(next->symbol!=old->symbol || next->group!=old->group || next->negate!=old->negate) {
                f_0a0b_01f1(491,256,x,y,next);
                *old=*next;
            }
            ++next;
            ++old;
        }
}

void game_06f3(void)
{
    Cell *old=&g_3415.cell[0][0];
    int x,y;
    Cell blank={0,0,2};
    int px=484,py=249;
    for(x=0;x<7;++x)
        for(y=0;y<7;++y) {
            *old=blank;
            ++old;
        }
    g_3415.group=-1;
    if(g_34d5) game_055b(&g_057a,0,0);
    else f_0c85_0b83(px,py,g_198e,g_40bc);
}

void game_0794(void)
{
    int slot;
    g_34e7=0;
    for(slot=0;slot<4;++slot) g_34d7[slot]=0;
}

void game_07c7(int slot,int color)
{
    int y=(color+1)*13;
    f_0c85_0b4f(0,y,321,y+11,g_198a,&g_3171[slot].sprite);
    g_3171[slot].color_index=color;
}

void game_081c(int x0,int y0,int x1,int y1,int px,int py)
{
    int y,x;
    for(x=0;x<=36;++x)
        for(y=0;y<=36;++y) {
            if(x<=x0-1 || x>=x1+1 || y<=y0-1 || y>=y1+1)
                g_1b55[x][y].kind=1;
            else g_1b55[x][y].kind=0;
        }
    f_0c85_0b4f(px,py,px+(x1-x0+1)*16-1,py+(y1-y0+1)*12-1,g_40bc,&g_3139);
}

void game_08de(void)
{
    int x,y;
    for(x=6;x<=30;++x)
        for(y=6;y<=30;++y)
            f_0c85_0b83((x-6)*16+1,(y-6)*11,&g_30f9,&g_3139);
    g_1b55[x][y].kind=0;
}

void game_094b(void)
{
    Snake *snake;
    int slot,n;
    Segment *segment;
    int modulus;
    for(slot=0;slot<4;++slot)
        if(g_34d7[slot]) {
            snake=&g_3171[slot];
            modulus=41;
            for(n=0;n<snake->length;++n) {
                segment=&snake->body[(n+snake->head_index)%modulus];
                f_0c85_0b83((segment->x-6)*16+1,(segment->y-6)*11,&g_30f9,&g_3139);
                g_1b55[segment->x][segment->y].kind=0;
            }
        }
}

void game_0a20(Image *destination,int kind,Segment *segment,Image *atlas)
{
    int x=(kind*4+segment->direction)*16+2,y=0;
    f_0c85_0bb2(x,y,x+15,y+11,atlas,(segment->x-6)*16+1,(segment->y-6)*11,destination);
}

void game_0a8b(int slot)
{
    Snake *snake=&g_3171[slot];
    int modulus=41;
    int n=(snake->head_index+snake->length-2)%modulus;
    Segment *tail,*before;
    before=&snake->body[n];
    n=(n+1)%modulus;
    tail=&snake->body[n];
    g_1b55[tail->x][tail->y].kind=4;
    tail->direction=before->direction;
    game_0a20(&g_3139,2,tail,&snake->sprite);
}

void game_0b44(int slot)
{
    Snake *snake=&g_3171[slot];
    int modulus=41;
    Segment *tail=&snake->body[(snake->head_index+snake->length-1)%modulus];
    f_0c85_0b83((tail->x-6)*16+1,(tail->y-6)*11,&g_30f9,&g_3139);
    g_1b55[tail->x][tail->y].kind=0;
    --snake->length;
    --snake->score;
    game_0a8b(slot);
}

void game_0bec(int slot,int direction,int trim)
{
    int modulus=41,kind;
    Snake *snake=&g_3171[slot];
    int remaining,previous_length=snake->length;
    Segment *head,*old=&snake->body[snake->head_index];
    BoardCell *cell=&g_1b55[old->x][old->y];
    Snake *victim;
    int victim_slot;
    g_3411=1;
    ++snake->length;
    ++snake->score;
    cell->kind=6;
    snake->head_index=(snake->head_index+modulus-1)%modulus;
    head=&snake->body[snake->head_index];
    head->x=old->x+g_043c[direction];
    head->y=old->y+g_0444[direction];
    head->direction=direction;
    cell=&g_1b55[head->x][head->y];
    if(cell->kind==4) {
        victim_slot=cell->owner;
        if(victim_slot!=slot) {
            long tick=f_0c10_000a();
            f_0c85_0b83((head->x-6)*16+1,(head->y-6)*11,&g_30d9,&g_3139);
            f_0c10_0016(tick,1L);
            f_0c85_0b83((head->x-6)*16+1,(head->y-6)*11,&g_30b9,&g_3139);
            f_0c10_0016(tick,2L);
            f_03f2_037a();
        }
        victim=&g_3171[victim_slot];
        remaining=--victim->length;
        --victim->score;
        if(remaining<=1) {
            if(remaining==1) {
                Segment *victim_head=&victim->body[victim->head_index];
                g_1b55[victim_head->x][victim_head->y].kind=4;
            } else --g_340f;
            if(g_1b4d[victim_slot]) {
                --g_1b41;
                g_1b4d[victim_slot]=0;
                if(g_34d5 && victim_slot==0) {
                    g_34d5=0;
                    game_06f3();
                }
            }
            if(g_1b45[victim_slot]) {
                --g_1b43;
                g_1b45[victim_slot]=0;
            }
        }
        if(remaining>0) game_0a8b(victim_slot);
        if(victim_slot!=slot) game_03de(victim_slot);
    } else if(trim) game_0b44(slot);
    cell->owner=slot;
    cell->kind=8;
    game_0a20(&g_3139,0,head,&snake->sprite);
    if(snake->length>2) {
        if(old->direction==head->direction) kind=1;
        else if((old->direction+1)%4==head->direction) kind=4;
        else kind=3;
        game_0a20(&g_3139,kind,old,&snake->sprite);
    }
    if(snake->length!=previous_length) game_03de(slot);
}

int game_0f27(void)
{
    int slot;
    char token;
    if(!g_1b43) {
        f_0c10_0016(g_3405,1L);
        g_3405=f_0c10_000a();
        *(Int4 *)g_1b45=*(Int4 *)g_1b4d;
        g_1b43=g_1b41;
    }
    if(g_40ff) {
        f_0e92_020a(&token,1);
        g_1b40=slot=token;
        if(g_1b40==14) game_046e();
    } else {
        slot=f_0b33_0d8f(4);
        while(!g_1b45[slot]) slot=(slot+1)%4;
    }
    if(g_4101) {
        token=slot;
        f_0e92_010a(&token,1);
    }
    if(slot<4) {
        g_1b45[slot]=0;
        --g_1b43;
    }
    return slot;
}

/* 0729:1002 (file 0x9292), complete routine. */
int game_1002(Match *left, Match *right)
{
    int difference;
    if (left->matched) {
        if (right->matched) {
            if ((difference = left->score - right->score) < 0)
                return 0;
            else if (difference == 0)
                return 1;
            else
                return 2;
        } else {
            return 2;
        }
    } else {
        if (right->matched)
            return 0;
        return 1;
    }
}

/* 0729:1058 (file 0x92E8), complete routine for valid game cards.
 * Locals deliberately follow observed stack order, simplifying compiler work.
 * Input values have groups 0..4, negate 0/1, anchors 0..6, symbols 0..9.
 */
void game_1058(Cell view[13][13],
                         Card *card, Match *result)
{
    int x, y, require_all;
    Cell *rule_cell;
    Cell *observed;
    int seen[5] = { 0, 0, 0, 0, 0 };
    int scores[5] = { 0, 0, 0, 0, 0 };
    int is_and[5] = { 1, 0, 0, 1, 1 };
    Byte group;
    Byte symbol;

    *result = g_049c;
    require_all = is_and[card->group];
    rule_cell = &card->cell[0][0];
    for (x = 0; x < 7; ++x) {
        observed = &view[6-card->anchor_x+x][6-card->anchor_y];
        for (y = 0; y < 7; ++y) {
            symbol = rule_cell->symbol;
            if (symbol != 9 && symbol != 8) {
                group = rule_cell->group;
                if ((observed->symbol == symbol) ^ rule_cell->negate) {
                    if (!(is_and[group] && seen[group] && scores[group] == 0))
                        ++scores[group];
                } else if (is_and[group]) {
                    if (require_all)
                        return;
                    scores[group] = 0;
                }
                seen[group] = 1;
            }
            ++rule_cell;
            ++observed;
        }
    }
    y = 0;
    for (x = 0; x < 5; ++x) {
        if (seen[x]) {
            if (require_all && scores[x] == 0)
                return;
            result->score += scores[x];
            ++y;
        }
    }
    if (y == 0 || result->score != 0)
        result->matched = 1;
}


int game_126a(int wait,int last)
{
    int selected,index;
    Rect *rect;
again:
        selected=-1;
        if(!f_03f2_0190(wait)) return selected;
        rect=g_040c;
        for(index=0;index<=last;++index) {
            if(rect->x0<=g_19ae && rect->x1>=g_19ae && rect->y0<=g_19b0 && rect->y1>=g_19b0) {
                selected=index;
                break;
            }
            ++rect;
        }
        if(selected==-1) {
            f_03f2_0304();
            if(wait) goto again;
            goto done;
        } else {
            if(selected!=5) {
                f_0c85_078a(g_40b2);
                f_0c85_0b83(rect->x0+5,rect->y0+3,g_19a2,g_40bc);
                if(!g_0db2) while(g_19bc);
                f_0c85_0b83(rect->x0+5,rect->y0+3,g_19a6,g_40bc);
                f_03f2_0247();
            }
            switch(selected) {
            case 0: case 2: case 4:
                if(g_34d5) {
                    g_34d5=0;
                    game_06f3();
                }
                break;
            case 1:
                if(g_34d7[0] && !g_40ff && !g_1af2) {
                    g_19bc=0;
                    f_03f2_0266();
                    f_044d_13d9(484,249,4,1,1);
                    f_03f2_0190(0);
                }
                if(g_1af4 || (g_40ff && g_34d7[0])) {
                    if(!g_34d5) {
                        g_34d5=1;
                        game_06f3();
                    }
                } else f_03f2_0304();
                break;
            case 3:
                if(g_19aa) f_0431_0136();
                else f_0431_0160();
                g_19aa=!g_19aa;
                break;
            default: break;
            }
        }
done:
    return selected;
}

int game_143c(int slot,int steps)
{
    do {
        Snake *snake=&g_3171[slot];
        Segment *head=&snake->body[snake->head_index];
        BoardCell *cell;
        int allowed[4]={1,1,1,1};
        int count,x,y,chosen,card,card_count,reflection,reflections[4];
        int head_x=head->x,head_y=head->y;
        int direction,index;
        Profile *profile;
        Match best,candidate,normal,mirrored;
        union { int control; struct { char pad,token; } bytes; } transient;
        Cell view[13][13];
        for(x=0;x<13;++x)
            for(y=0;y<13;++y) {
                cell=&g_1b55[head_x+x-6][head_y+y-6];
                if((view[x][y].symbol=cell->kind)>=4 && cell->owner!=slot)
                    view[x][y].symbol--;
            }
        allowed[(snake->body[snake->head_index].direction+2)%4]=0;
        count=3;
        for(x=0;x<4;++x)
            if(allowed[x]==1)
                switch(view[6+g_043c[x]][6+g_0444[x]].symbol) {
                case 1: case 5: case 6: case 7:
                    allowed[x]=0;
                    --count;
                    break;
                default: break;
                }
        if(count) {
            if(g_40ff) {
                f_0e92_020a(&transient.bytes.token,1);
                g_1b40=direction=transient.bytes.token;
                if(g_1b40==14) game_046e();
            } else {
                chosen=-1;
                best=g_049c;
                profile=g_34d7[slot];
                card_count=profile->card_count;
                for(card=0;card<card_count;++card) {
                    count=0;
                    for(direction=0;direction<4;++direction)
                        if(allowed[direction]) {
                            game_1058(view,&g_1b3c[slot][direction][0][card],&normal);
                            game_1058(view,&g_1b3c[slot][direction][1][card],&mirrored);
                            if(game_1002(&normal,&mirrored)==0) {
                                candidate=mirrored;
                                reflection=1;
                            } else {
                                candidate=normal;
                                reflection=0;
                            }
                            reflections[direction]=reflection;
                            switch(game_1002(&candidate,&best)) {
                            case 0: allowed[direction]=0; break;
                            case 1: ++count; break;
                            case 2:
                                count=1;
                                best=candidate;
                                for(index=0;index<direction;++index) allowed[index]=0;
                            }
                        }
                    if(game_1002(&g_049c,&best)!=1) {
                        chosen=card;
                        break;
                    }
                }
                if(count>1) direction=f_0b33_0d8f(4);
                else direction=0;
                while(!allowed[direction]) direction=(direction=(direction+1)%4);
            }
            if(g_34d5 && slot==0) {
                if(g_40ff) {
                    if(direction>=4) g_34ad=direction;
                } else {
                    if(chosen==-1) game_055b(&g_057a,direction,0);
                    else game_055b(&profile->cards[chosen],direction,reflections[direction]);
                }
                while(1) {
                    disable();
                    transient.control=g_34ad;
                    g_34ad=-1;
                    enable();
                    switch(transient.control) {
                    case 4: return transient.control;
                    case 0: case 1: goto move;
                    case 2: return 6;
                    default: continue;
                    }
                }
            }
move:
            game_0bec(slot,direction,1);
            if(g_4101) {
                transient.bytes.token=direction;
                f_0e92_010a(&transient.bytes.token,1);
            }
        }
    } while(--steps>0);
    return 0;
}

int game_18eb(int slot,int direction,int x,int y,int unused)
{
    Segment *segment;
    Snake *snake=&g_3171[slot];
    if(snake->length==0) {
        snake->length=1;
        ++snake->score;
        snake->head_index=40;
        segment=&snake->body[snake->head_index];
        segment->x=x;
        segment->y=y;
        segment->direction=direction;
        game_0a20(&g_3139,1,segment,&snake->sprite);
    }
    if(snake->length<10) {
        game_0bec(slot,direction,0);
        return 1;
    } else {
        game_0a8b(slot);
        return 0;
    }
}

void game_198e(int slot,int direction,int x,int y,int unused)
{
    g_3171[slot].length=0;
    while(game_18eb(slot,direction,x,y,unused));
}

int game_19bd(int slot)
{
    int changed;
    if(g_1b08[slot]!=g_1b20[slot] || g_1b00[slot]!=g_1b18[slot]) {
        changed=1;
        f_0c85_0b83(g_1b08[slot],g_1b00[slot],g_34c3[slot],g_40bc);
        g_1b08[slot]+=g_1b10[slot];
        if((g_1b10[slot]>0 && g_1b08[slot]>g_1b20[slot]) ||
           (g_1b10[slot]<0 && g_1b08[slot]<g_1b20[slot]))
            g_1b08[slot]=g_1b20[slot];
        g_1b00[slot]+=g_1af8[slot];
        if((g_1af8[slot]>0 && g_1b00[slot]>g_1b18[slot]) ||
           (g_1b10[slot]<0 && g_1b00[slot]<g_1b18[slot]))
            g_1b00[slot]=g_1b18[slot];
        f_0c85_0bb2(g_1b08[slot],g_1b00[slot],
            g_044c[slot].x1-g_044c[slot].x0+g_1b08[slot],
            g_044c[slot].y1-g_044c[slot].y0+g_1b00[slot],
            g_40bc,0,0,g_34c3[slot]);
        f_0c85_0b83(g_1b08[slot],g_1b00[slot],g_3159[slot],g_40bc);
    } else changed=0;
    return changed;
}

void game_1bb0(void)
{
    int slot,next;
    int x[4]={18,6,18,30};
    int y[4]={30,18,6,18};
    int working,first;
    int directions[4];
    next=0;
    for(slot=0;slot<4;++slot) {
        Gate *gate=&g_044c[slot];
        directions[slot]=next;
        g_1b30[slot]=gate->x0;
        g_1b28[slot]=gate->y0;
        g_1b20[slot]=gate->x;
        g_1b18[slot]=gate->y;
        g_1b10[slot]=g_1b20[slot]-g_1b30[slot];
        if(g_1b10[slot]>0) g_1b10[slot]=2;
        else if(g_1b10[slot]<0) g_1b10[slot]=-2;
        g_1b08[slot]=g_1b30[slot];
        g_1af8[slot]=g_1b18[slot]-g_1b28[slot];
        if(g_1af8[slot]>0) g_1af8[slot]=2;
        else if(g_1af8[slot]<0) g_1af8[slot]=-2;
        g_1b00[slot]=g_1b28[slot];
        next=(next+1)%4;
        g_3171[slot].length=0;
    }
    do {
        long tick=f_0c10_000a();
        working=0;
        for(slot=0;slot<4;++slot) working|=game_19bd(slot);
        f_03f2_037a();
        f_0c10_0016(tick,1L);
    } while(working);
    first=1;
    do {
        long tick=f_0c10_000a();
        working=0;
        for(slot=0;slot<4;++slot)
            if(g_34d7[slot]) {
                int direction=directions[slot];
                Rect *rect;
                if(first) {
                    int px=(direction+4)*16+1,py=0;
                    rect=&g_047c[direction];
                    f_0c85_0a6a(&g_34b3[slot],rect->x1-rect->x0+1,rect->y1-rect->y0+1,0,0,0);
                    f_0c85_0bb2(rect->x0,rect->y0,rect->x1,rect->y1,g_40bc,0,0,g_34b3[slot]);
                    f_0c85_0bb2(px,py,px+rect->x1-rect->x0,py+rect->y1-rect->y0,
                        &g_3171[slot].sprite,rect->x0,rect->y0,g_40bc);
                }
                working|=game_18eb(slot,direction,x[direction],y[direction],1);
                if(!working) {
                    rect=&g_047c[direction];
                    f_0c85_0b83(rect->x0,rect->y0,g_34b3[slot],g_40bc);
                    f_0c85_0b2f(&g_34b3[slot]);
                }
            }
        first=0;
        f_0c10_0016(tick,1L);
    } while(working);
    for(slot=0;slot<4;++slot) {
        int px=g_1b30[slot],py=g_1b28[slot];
        g_1b30[slot]=g_1b20[slot];
        g_1b28[slot]=g_1b18[slot];
        g_1b20[slot]=px;
        g_1b18[slot]=py;
        g_1b10[slot]=g_1b20[slot]-g_1b30[slot];
        if(g_1b10[slot]>0) g_1b10[slot]=2;
        else if(g_1b10[slot]<0) g_1b10[slot]=-2;
        g_1b08[slot]=g_1b30[slot];
        g_1af8[slot]=g_1b18[slot]-g_1b28[slot];
        if(g_1af8[slot]>0) g_1af8[slot]=2;
        else if(g_1af8[slot]<0) g_1af8[slot]=-2;
        g_1b00[slot]=g_1b28[slot];
    }
    do {
        long tick=f_0c10_000a();
        working=0;
        for(slot=0;slot<4;++slot) working|=game_19bd(slot);
        f_03f2_037a();
        f_0c10_0016(tick,1L);
    } while(working);
}

void game_20a9(void)
{
    int slot;
    f_0c85_0b83(0,0,g_3169,&g_3119);
    g_34b1=25;
    g_34af=0;
    g_1b41=g_1b43=0;
    for(slot=0;slot<4;++slot)
        if(g_34d7[slot]) {
            g_1b4d[slot]=1;
            ++g_1b41;
        } else g_1b4d[slot]=0;
    g_340f=g_1b41;
}

int game_2123(void)
{
    int control=g_34ad;
    g_34ad=-1;
    if(control==2) return 6;
    if(control==4) return control;
    if(g_340f==1 && !g_3413) return 6;
    if(!g_1b43) {
        if(!g_3411) return 6;
        g_3411=0;
        if(--g_34b1==0) {
            int x;
            g_34b1=25;
            x=g_34af*7;
            f_0c85_0ead(x+1,1,x+6,9,&g_3119,0);
            ++g_34af;
            if(g_34af==22) return 6;
        }
    }
    return 0;
}

void game_21bf(int slot)
{
    Snake *snake=&g_3171[slot];
    int color=g_34d7[slot]->color;
    snake->length=0;
    snake->score=0;
    snake->unknown_04=0;
    game_07c7(slot,color);
}

void game_220a(void)
{
    f_0c85_0958(g_04e9,&g_198a);
    f_0c85_0b4f(2,0,17,11,g_198a,&g_30f9);
    f_0c85_0b4f(66,0,81,11,g_198a,&g_30d9);
    f_0c85_0b4f(34,0,49,11,g_198a,&g_30b9);
}

void game_2289(void)
{
    f_0c85_0b2f(&g_198a);
}

void game_2296(void)
{
    long tick;
    int n;
    for(n=0;n<3;++n) {
        tick=f_0c10_000a();
        f_03f2_0304();
        f_0c10_0016(tick,3L);
    }
}

void game_22d5(int a,int b,int c)
{
    g_1b38(a,b,c);
    f_0df6_007f(g_1b38);
    enable();
    g_34ad=game_126a(0,5);
    g_19bc=0;
    disable();
    g_1b38=f_0df6_007f(game_22d5);
}

/* These block temporaries occupy mutually reused stack locations in the
   executable. The union expresses that reuse without assembler or stack
   addresses; unused bytes are padding, never executable content. */
typedef union GameWork {
    struct { char unused[15]; char token; } rec;
    struct { char unused[12]; Gate *gate; } gate;
    struct { char unused[8]; int color,previous; Profile *profile; } colors;
    struct { char unused[2]; int length; char *name; Image *atlas;
        Segment segment; char pad; } preview;
    struct { char unused[8]; char **text; Rect *rect; } buttons;
    struct { char unused[14]; int slot; } count;
    struct { char unused[11]; char marker; int snake,code; } play;
    struct { int increment,delta; Profile *profile; Snake *snake;
        int best,winner; } rating;
    Profile *winner_profile;
} GameWork;

void game_2327(char *filename)
{
    int slot,selected,first=1;
    Snake *snake;
    GameWork work;
    InputState saved;
    int positions[4][2]={{240,185},{36,185},{36,26},{240,26}};
    Image preview;
    f_0431_0136();
    f_0431_018d();
    f_0431_008e(g_04f5);
    if(g_19aa) f_0431_0109();
    f_0c85_0f74();
    f_0c85_09ea(g_04fa,g_40bc);
    game_220a();
    f_0c85_0958(g_0504,&g_316d);
    f_0c85_0958(g_050d,&g_3169);
    f_0c85_0958(g_0516,&g_3159[2]);
    f_0c85_0958(g_0522,&g_3159[3]);
    f_0c85_0958(g_052e,&g_3159[0]);
    f_0c85_0958(g_053a,&g_3159[1]);
    f_0c85_0b4f(473,94,627,104,g_40b8,&g_3119);
    for(slot=0;slot<4;++slot) {
        work.gate.gate=&g_044c[slot];
        f_0c85_0a6a(&g_34c3[slot],work.gate.gate->x1-work.gate.gate->x0+1,
            work.gate.gate->y1-work.gate.gate->y0+1,0,0,0);
        f_0c85_0bb2(work.gate.gate->x0,work.gate.gate->y0,work.gate.gate->x1,
            work.gate.gate->y1,g_40bc,0,0,g_34c3[slot]);
        f_0c85_0b83(work.gate.gate->x0,work.gate.gate->y0,g_3159[slot],g_40bc);
    }
reload:
    /* Preserve the original integer/pointer comparison, including its
       Borland warning: the executable sign-extends *filename to 32 bits. */
    if(*filename!=g_0546) {
        f_0e92_005c();
        f_0e92_0008(filename);
    }
    if(g_40ff) {
        while(1) {
            f_0e92_020a(&work.rec.token,1);
            if(work.rec.token==12) break;
            slot=work.rec.token;
            g_34d7[slot]=f_0b33_002a(sizeof(Profile));
            f_0e92_020a(g_34d7[slot],105);
        }
        f_0e92_00f8();
    }
    if(g_4101) {
        if(!f_0e92_0067(g_0548)) f_0b33_0003(g_0550);
        for(slot=0;slot<4;++slot)
            if(g_34d7[slot]) {
                work.rec.token=slot;
                f_0e92_010a(&work.rec.token,1);
                f_0e92_010a(g_34d7[slot],105);
            }
        work.rec.token=12;
        f_0e92_010a(&work.rec.token,1);
        f_0e92_00f8();
    }
    if(!first) goto round;
    {
        snake=g_3171;
        for(slot=0;slot<4;++slot) {
            work.colors.profile=g_34d7[slot];
            if(work.colors.profile) {
                game_21bf(slot);
                work.colors.color=work.colors.profile->color;
                for(work.colors.previous=0;work.colors.previous<slot;++work.colors.previous)
                    if(g_34d7[work.colors.previous])
                        if(g_34d7[work.colors.previous]->color==work.colors.color) {
                            if(work.colors.previous!=0) game_07c7(work.colors.previous,work.colors.previous);
                            game_07c7(slot,slot);
                        }
            }
            ++snake;
        }
        snake=g_3171;
        f_0c85_0458();
        for(slot=0;slot<4;++slot) {
            if(g_34d7[slot]) {
                work.preview.atlas=&g_3171[slot].sprite;
                f_0c85_0b4f(g_03ac[slot].x0,g_03ac[slot].y0,g_03ac[slot].x1,g_03ac[slot].y1,g_40bc,&preview);
                work.preview.segment.x=6;
                work.preview.segment.y=6;
                work.preview.segment.direction=3;
                game_0a20(&preview,0,&work.preview.segment,work.preview.atlas);
                work.preview.segment.x++;
                game_0a20(&preview,1,&work.preview.segment,work.preview.atlas);
                work.preview.segment.x++;
                game_0a20(&preview,1,&work.preview.segment,work.preview.atlas);
                work.preview.name=g_34d7[slot]->name;
                work.preview.length=strlen(work.preview.name);
                f_0c85_049d(g_40bc,g_03cc[slot].x0+(9-work.preview.length)*8/2,
                    g_03cc[slot].y0-2,work.preview.name);
                f_0c85_0467(2);
                f_0c85_05a5(g_40bc,g_03ec[slot].x0,g_03ec[slot].y0-3,0);
                f_0c85_0467(1);
            }
            ++snake;
        }
        f_0c85_0449();
        work.buttons.rect=g_040c;
        work.buttons.text=g_1862;
        for(slot=0;slot<=4;++slot) {
            f_0c85_049d(g_40bc,work.buttons.rect->x0+38,work.buttons.rect->y0+4,*work.buttons.text);
            ++work.buttons.text;
            ++work.buttons.rect;
        }
        g_34d3=1;
        g_34d5=0;
        game_06f3();
        g_3409=1;
        f_0c85_0c0e(22,14,442,309,g_40bc,22,14,g_40b8,20);
        f_0c85_0fe1();
        f_0c85_0fb1();
        work.buttons.rect=&g_040c[5];
        f_03f2_00b9(&saved);
        f_03f2_015e(work.buttons.rect->x0,work.buttons.rect->y0,work.buttons.rect->x1,work.buttons.rect->y1);
        game_081c(6,6,30,30,32,24);
        g_340d=0;
        g_1b41=0;
        for(work.count.slot=0;work.count.slot<4;++work.count.slot)
            if(g_34d7[work.count.slot]) {
                ++g_1b41;
                f_044d_005b(positions[work.count.slot][0],positions[work.count.slot][1],g_34d7[work.count.slot]);
            }
        g_3413=(g_1b41==1);
        game_015b();
newround:
        g_340b=1;
menu:
        g_1b40=0;
        selected=game_126a(1,4);
        switch(selected) {
        case 0: case 1:
            if(*filename==g_0545 || !first) goto reload;
round:
            first=0;
            if(g_340b) {
                f_0c85_078a(g_40b2);
                game_20a9();
                if(g_3409) {
                    f_0c85_0f74();
                    f_0c85_0fb1();
                    game_08de();
                    f_0c85_0bb2(491,256,442,309,g_40bc,491,256,g_40b8);
                    f_0c85_0c0e(22,14,442,309,g_40b8,22,14,g_40bc,20);
                    f_0c85_0f74();
                    f_0c85_0fb1();
                    g_3409=0;
                } else game_094b();
                if(g_40ff) {
                    f_0e92_020a(&g_1b40,1);
                    f_0e92_01f6(&g_1b40);
                    if(g_1b40==13) goto finished;
                } else ++g_340d;
                game_1bb0();
                g_3411=1;
                g_340b=0;
                f_03f2_0247();
            }
            disable();
            g_1b38=f_0df6_007f(game_22d5);
            g_0db2=1;
            enable();
            while(1) {
                work.play.code=game_2123();
                if(work.play.code) break;
                work.play.snake=game_0f27();
                if(g_40ff && work.play.snake>=4) {
                    work.play.code=work.play.snake;
                    break;
                }
                work.play.code=game_143c(work.play.snake,1);
                if(work.play.code) break;
            }
            disable();
            f_0df6_007f(g_1b38);
            g_0db2=0;
            enable();
            game_2296();
            if(g_4101) {
                work.play.marker=14;
                f_0e92_010a(&work.play.marker,1);
                game_04cc();
            }
            if(g_40ff) {
                if(work.play.code==4) goto finished;
                if(g_1b40==14) work.play.code=2;
                else if(g_1b40==13) work.play.code=4;
                else if(work.play.code!=4) work.play.code=game_051e();
            }
            if(work.play.code==4) goto finished;
            goto newround;
            goto newround;
        case 2: case 3: goto menu;
        case 4:
finished:
            if(g_40ff)
                while(g_1b40!=13) game_051e();
        }
    }
    if(!g_3413 && g_340d) {
        work.rating.winner=-1;
        work.rating.best=-1;
        work.rating.snake=g_3171;
        for(slot=0;slot<4;++slot) {
            if(g_34d7[slot]) {
                work.rating.profile=g_34d7[slot];
                work.rating.profile->completed_rounds+=g_340d;
                work.rating.delta=work.rating.snake->score-g_340d*10;
                work.rating.increment=work.rating.delta/work.rating.profile->completed_rounds;
                if(work.rating.increment==0) {
                    if(work.rating.delta>0) work.rating.increment=1;
                    else if(work.rating.delta<0) work.rating.increment=-1;
                }
                work.rating.profile->rating+=work.rating.increment;
                if(!g_40ff) f_0b33_0c6b(work.rating.profile->name,work.rating.profile);
                if(work.rating.snake->score>work.rating.best) {
                    work.rating.best=work.rating.snake->score;
                    work.rating.winner=slot;
                } else if(work.rating.snake->score==work.rating.best) work.rating.winner=-1;
            }
            ++work.rating.snake;
        }
        if(work.rating.winner!=-1) {
            work.winner_profile=g_34d7[work.rating.winner];
            f_044d_005b(140,108,work.winner_profile);
            f_0b33_09f4(10000);
        }
    }
    f_03f2_0266();
    f_0c85_0b2f(&g_316d);
    f_0c85_0b2f(&g_3169);
    game_2289();
    f_0c85_0b2f(&g_3159[0]);
    f_0c85_0b2f(&g_3159[1]);
    f_0c85_0b2f(&g_3159[2]);
    f_0c85_0b2f(&g_3159[3]);
    for(slot=0;slot<4;++slot) f_0c85_0b2f(&g_34c3[slot]);
    f_03f2_0125(&saved);
    if(g_40ff) {
        for(slot=0;slot<4;++slot)
            if(g_34d7[slot]) {
                f_0b33_0063(g_34d7[slot]);
                g_34d7[slot]=0;
            }
    }
    if(g_4101) {
        work.rec.token=13;
        f_0e92_010a(&work.rec.token,1);
        f_0e92_010a(&work.rec.token,1);
        f_0e92_00c1();
    }
    game_03c7();
    f_0431_0136();
    f_0431_018d();
    f_0431_008e(g_056a);
    if(g_19aa) f_0431_0109();
}
