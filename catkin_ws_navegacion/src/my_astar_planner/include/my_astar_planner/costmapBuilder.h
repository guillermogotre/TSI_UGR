#ifndef _COSTMAP_BUILDER
#define _COSTMAP_BUILDER

#include <ros/ros.h>
#include <fstream>

#include <vector>
#include <map>
#include <set>
#include <utility>

namespace costmap_builder{
    struct MapSection{
        unsigned int begin;
        unsigned int end;
        unsigned int sec;
        int target;
    };

    struct Block{
        std::vector<std::pair<int,int> > l;
        std::pair<int,int> average;
        int avCost;
    };

    class CostmapBuilder{
    private:
        unsigned char THRESHOLD;
        unsigned int MARGIN;
        unsigned char * costMap;
        std::vector<std::vector<int> > rowMap, colMap, interMap;
        unsigned int cellsX, cellsY;
        int maxn;

        //La chicha
        std::map<std::pair<int,int>,int> corresp;
        std::vector<Block> blocks;
        std::map<int,std::set<int> > arbol;


        unsigned char getCost(unsigned int y,unsigned int x){
            return costMap[y*cellsX + x];
        }
    public:
        CostmapBuilder(){
        }

        CostmapBuilder(unsigned char * costMap, unsigned int cellsX, unsigned int cellsY)
            :rowMap(cellsY,std::vector<int>(cellsX)),
            colMap(cellsY,std::vector<int>(cellsX)),
            interMap(cellsY,std::vector<int>(cellsX))
        {
            THRESHOLD = 127;
            MARGIN = 4;
            this->costMap = costMap;
            this->cellsX = cellsX;
            this->cellsY = cellsY;
        }

        struct Node{
            int parent;
            int classVal;
            int g;
            int h;
            int f;
            int avCost;
            void calcF(){
                int incrCost = (1 + 3*avCost/127);
                f=g+h*incrCost;
            };     
        };

        struct compNode{
            bool operator()(const Node & n1, const Node & n2){
                return n1.f < n2.f;
            }
        };

        int euclDist(std::pair<int,int> & ori, std::pair<int,int> & goal){
            return abs(goal.first - ori.first) + abs(goal.second - ori.second);
        }

        int totalDist(std::pair<int,int> & p1, std::pair<int,int> & p2, std::pair<int,int> & p3){
            return euclDist(p1,p2) + euclDist(p2,p3);
        }

        std::vector<std::vector<std::pair<int,int> > > getBlocks(int ori_y, int ori_x, int goal_y, int goal_x){
            /* Descomentar para versión jerárquica
            std::vector<std::vector<std::pair<int,int> > > empty;
            return empty;
            */
            std::pair<int,int> 
                ori = std::make_pair(ori_y,ori_x), 
                goal = std::make_pair(goal_y, goal_x);
            int 
                ori_class = corresp.find(ori)->second,
                goal_class = corresp.find(goal)->second;
            
            interMap[ori_y][ori_x] = blocks.size()-1;
            interMap[goal_y][goal_x] = blocks.size()-1;
            

            std::multiset<Node,compNode> abiertos;
            std::set<int> abiertos_index;
            std::map<int,Node> cerrados;

            std::vector<std::vector<std::pair<int,int> > > res;
            
            int current_class = ori_class;
            std::pair<int,int> current_av = ori;
            
            Node n = {ori_class, ori_class, 0, euclDist(ori,goal), 0};
            n.calcF();
            /*
                Visited map
            */
            std::vector<std::vector<int> > visited(cellsY, std::vector<int>(cellsX,-1));
            
            abiertos.insert(n);
            abiertos_index.insert(ori_class);
            ////ROS_INFO("From %d to %d",ori_class, goal_class);
            while(!abiertos.empty()){
                Node c = *(abiertos.begin());
                ////ROS_INFO("ABIERTO: %d [%d,%d,%d]",c.classVal,c.g,c.h,c.f);
                abiertos.erase(abiertos.begin());
                abiertos_index.erase(abiertos_index.find(c.classVal));
                cerrados.insert(std::make_pair(c.classVal,c));

                /*
                    Mapas de depuracion
                    ||
                    \/
                */
                interMap[blocks[c.classVal].average.first][blocks[c.classVal].average.second] = blocks.size()-1;

                for(std::vector<std::pair<int,int> >::iterator it=blocks[c.classVal].l.begin(); it!=blocks[c.classVal].l.end(); it++){
                    visited[it->first][it->second]=10000;
                }
                //hasta aquí

                //Si hemos llegado
                if(c.classVal == goal_class){
                    //Construye lista
                    //Termina
                    Node n = cerrados.find(goal_class)->second;
                    current_class = n.parent;

                    while(current_class != ori_class){
                        res.push_back(blocks[current_class].l);
                        current_class = cerrados.find(current_class)->second.parent;
                    }

                    break;
                }
                //En otro caso continuamos
                for(std::set<int>::iterator it = arbol[c.classVal].begin(); it != arbol[c.classVal].end(); it++){
                    if(cerrados.count(*it) != 0)
                        continue;
                    Node n = {
                        c.classVal, 
                        *it, 
                        c.g + euclDist(blocks[c.classVal].average, blocks[*it].average),
                        euclDist(blocks[*it].average, goal),
                        0,
                        blocks[*it].avCost
                        };
                    n.calcF();
                    ////ROS_INFO("Metiendo: %d", n.classVal);
                    if(abiertos_index.count(*it) != 0){
                        for(std::set<Node,compNode>::iterator it2=abiertos.begin(); it2!=abiertos.end(); it2++){
                            if(it2->classVal == *it){
                                if(n.f > it2->f){
                                    abiertos.erase(it2);
                                    abiertos.insert(n);                                    
                                }
                                break;
                            }
                        }
                    }else{
                        abiertos.insert(n);
                        abiertos_index.insert(n.classVal);
                    }
                }
            }
            std:reverse(res.begin(),res.end());
            paintMap(interMap, "interMap2.pgm");
            paintMap(visited,"visited.pgm");

            {
                std::vector<std::vector<int> > propagacion(cellsY, std::vector<int>(cellsX,-1));
                std::set<int> abiertos;
                std::set<int> cerrados;
                abiertos.insert(ori_class);
                while(!abiertos.empty()){
                    int c = *abiertos.begin();
                    abiertos.erase(abiertos.begin());
                    cerrados.insert(c);
                    //Pintamos
                    for(std::vector<std::pair<int,int> >::iterator it=blocks[c].l.begin(); it!= blocks[c].l.end(); it++){
                        propagacion[it->first][it->second] = 10000;
                    }
                    //Añadimos
                    for(std::set<int>::iterator it=arbol[c].begin(); it!= arbol[c].end(); it++){
                        if(cerrados.count(*it) == 0){
                            abiertos.insert(*it);
                        }
                    }
                }
                paintMap(propagacion,"propagacion.pgm");
            }

            return res;
        }
        
        void buildMap(){
            int n = -1;
            std::vector<MapSection> rowSections, colSections;
            bool begin = true;
            MapSection sec;
            ROS_INFO("Analizando mapa");
            ROS_INFO("Definiendo plano horizontal");
            for(unsigned int y=0; y<cellsY; y++){
                sec.sec = y;
                for(unsigned int x=0; x<cellsX; x++){
                    //////ROS_INFO("Build: [%u,%u] %u", y,x,(unsigned int)costMap[y*cellsX + x]);
                    if (getCost(y,x) > THRESHOLD){
                        //////ROS_INFO("PUM!");
                        if(!begin){
                            sec.end = x;
                            rowSections.push_back(sec);
                            begin = true;
                            ////ROS_INFO("Cierra: %u -> %u",sec.begin, sec.end);
                        }
                        rowMap[y][x] = -1;
                    }
                    else{
                        if(begin){
                            n++;
                            maxn = n;
                            begin = false;
                            sec.begin = x;
                            sec.target = n;
                        }
                        rowMap[y][x] = n;
                    }
                }
                if(!begin){
                    sec.end = cellsX;
                    rowSections.push_back(sec);
                    begin = true;
                    ////ROS_INFO("Cierra: %u -> %u",sec.begin, sec.end);
                }
            }
            
            //Se que la ultima fila no pertenece al problema
            ROS_INFO("Construyendo plano horizontal");
            for(unsigned int y=0; y<cellsY-1; y++){
                begin = true;
                for(unsigned int x=0; x<cellsX; x++){
                    ////ROS_INFO("[%u,%u]:%d",x,y,rowMap[y][x]);
                    if(rowMap[y][x] != -1){
                        int secN = rowMap[y][x];
                        ////ROS_INFO("1: %lu", rowSections.size());
                        MapSection current = rowSections[secN];
                        ////ROS_INFO("1");
                        int currentRep = current.begin + ((current.end - current.begin)/2);
                        ////ROS_INFO("1");
                        //Hay fila abajo candidata
                        ////ROS_INFO("#[%u,%u](%u)",current.begin,current.end,secN);
                        if(rowMap[y+1][currentRep] != -1){
                            MapSection candidate = rowSections[rowMap[y+1][currentRep]];
                            ////ROS_INFO("![%u,%u](%u)",candidate.begin,candidate.end,rowMap[y+1][currentRep]);
                            if(
                                abs(candidate.begin - current.begin) <= MARGIN &&
                                abs(candidate.end - current.end) <= MARGIN
                            ){
                                ////ROS_INFO("Pintar: %u ... %u", candidate.begin, candidate.end);
                                rowSections[rowMap[y+1][currentRep]].target = current.target;
                            }
                        }
                        ////ROS_INFO("[%u]Currend end: [%u] %u",y,x,current.end);
                        x = current.end;
                    }
                }
                ////ROS_INFO("FOR: %u",y);
            }
            for(std::vector<MapSection>::iterator it=rowSections.begin(); it!=rowSections.end(); it++){
                MapSection m = *it;
                for(int i=m.begin; i <m.end; i++){
                    rowMap[m.sec][i] = m.target;
                }
            }

            
            
            paintMap(rowMap,"rowMap.pgm");

            /*
                Plano vertical
            */
            ROS_INFO("Definiendo plano vertical");
            n=-1;
            begin = true;
            for(unsigned int x=0; x<cellsX; x++){
                sec.sec = x;
                for(unsigned int y=0; y<cellsY; y++){
                    ////ROS_INFO("Build: [%u,%u] %u", y,x,(unsigned int)costMap[y*cellsX + x]);
                    if (getCost(y,x) > THRESHOLD){
                        ////ROS_INFO("PUM!");
                        if(!begin){
                            sec.end = y;
                            colSections.push_back(sec);
                            begin = true;
                            ////ROS_INFO("Cierra: %u -> %u",sec.begin, sec.end);
                        }
                        colMap[y][x] = -1;
                    }
                    else{
                        if(begin){
                            n++;
                            maxn = n;
                            begin = false;
                            sec.begin = y;
                            sec.target = n;
                        }
                        colMap[y][x] = n;
                    }
                }
                if(!begin){
                    sec.end = cellsY;
                    colSections.push_back(sec);
                    begin = true;
                    ////ROS_INFO("Cierra: %u -> %u",sec.begin, sec.end);
                }
            }
            
            //Se que la ultima fila no pertenece al problema
            ROS_INFO("Construyendo plano vertical");
            for(unsigned int x=0; x<cellsX-1; x++){
                begin = true;
                for(unsigned int y=0; y<cellsY; y++){
                    ////ROS_INFO("[%u,%u]:%d",x,y,colMap[y][x]);
                    if(colMap[y][x] != -1){
                        int secN = colMap[y][x];
                        ////ROS_INFO("1: %lu", colSections.size());
                        MapSection current = colSections[secN];
                        ////ROS_INFO("1");
                        int currentRep = current.begin + ((current.end - current.begin)/2);
                        ////ROS_INFO("1");
                        //Hay fila abajo candidata
                        ////ROS_INFO("#[%u,%u](%u)",current.begin,current.end,secN);
                        if(colMap[currentRep][x+1] != -1){
                            MapSection candidate = colSections[colMap[currentRep][x+1]];
                            ////ROS_INFO("![%u,%u](%u)",candidate.begin,candidate.end,colMap[currentRep][x+1]);
                            ////ROS_INFO("1");
                            if(
                                abs(candidate.begin - current.begin) <= MARGIN &&
                                abs(candidate.end - current.end) <= MARGIN
                            ){
                                //ROS_INFO("Pintar: %u ... %u", candidate.begin, candidate.end);
                                colSections[colMap[currentRep][x+1]].target = current.target;
                            }
                        }
                        //ROS_INFO("[%u]Currend end: [%u] %u",y,x,current.end);
                        y = current.end;
                    }
                }

                //ROS_INFO("FOR: %u",x);
            }
            for(std::vector<MapSection>::iterator it=colSections.begin(); it!=colSections.end(); it++){
                MapSection m = *it;
                for(int i=m.begin; i <m.end; i++){
                    colMap[i][m.sec] = m.target;
                }
            }
            paintMap(colMap,"colMap.pgm");

            /*
                Intersection
            */
           ROS_INFO("Construyendo intersección");
            std::map<std::pair<int,int>,int> interVals;
            n = 0;
            for(int y=0; y<cellsY; y++){
                for(int x=0; x<cellsX; x++){
                    if(rowMap[y][x] == -1){
                        interMap[y][x] = -1;
                        continue;
                    }
                    int classVal;
                    std::pair<int,int> b = std::make_pair(rowMap[y][x],colMap[y][x]);
                    if(interVals.count(b) != 0){
                        classVal = interVals.find(b)->second;
                    }else{
                        interVals.insert(std::make_pair(b,n));
                        classVal = n;
                        blocks.push_back(Block());
                        n++;
                    }
                    interMap[y][x] = classVal;
                    std::pair<int,int> p = std::make_pair(y,x);
                    blocks[classVal].l.push_back(p);
                    corresp.insert(std::make_pair(p,classVal));
                }
            }
            paintMap(interMap,"interMap.pgm");
            ROS_INFO("Imprimiendo interMap.pgm a .ros path");
            //Eliminar bloques pequeños
            
            /*
                Copy intermap
            */
            std::vector<std::vector<int> > borderMap(cellsY,std::vector<int>(cellsX));
            for(int i=0; i<cellsY; i++){
                for(int j=0; j<cellsX; j++){
                    borderMap[i][j] = interMap[i][j];
                }
            }

            ROS_INFO("Calculando vecinos");
            //Calcular vecinos
            for(int y=0; y<cellsY-1; y++){
                for(int x=0; x<cellsX-1; x++){
                    if(interMap[y][x] != -1){
                        int val = interMap[y][x];
                        for(int i=0; i<=1; i++){
                            for(int j=0; j<=1; j++){
                                if((i!=0 || j!=0) && (interMap[y+i][x+j] != val) && (interMap[y+i][x+j] != -1)){
                                    int neighVal = interMap[y+i][x+j];
                                    arbol[val].insert(neighVal);
                                    arbol[neighVal].insert(val);
                                    borderMap[y][x] = 1000;
                                }
                            }
                        }
                    }
                }
            }
            maxn = blocks.size();
            ROS_INFO("Imprimiendo borderMap.pgm a .ros path");
            paintMap(borderMap,"borderMap.pgm");

            ROS_INFO("Eliminando bloques pequeños");
            //Eliminar pequeños
            int THRES = 5;
            for(int i=0; i<blocks.size(); i++){
                int currentBlock = i;
                int miny = INT_MAX,
                    minx = INT_MAX,
                    maxy = INT_MIN,
                    maxx = INT_MIN;
                for(std::vector<std::pair<int,int> >::iterator it = blocks[currentBlock].l.begin(); it != blocks[currentBlock].l.end(); it++){
                    miny = (it->first < miny)?it->first:miny;
                    maxy = (it->first > maxy)?it->first:maxy;
                    minx = (it->second < minx)?it->second:minx;
                    maxx = (it->second > maxx)?it->second:maxx;
                }
                int min_dim = std::min(maxy-miny,maxx-minx);
                ////ROS_INFO("Block %d [%lu]", currentBlock, blocks.size());
                if(blocks[currentBlock].l.size() < THRES){
                //if(min_dim < THRES){
                    //ROS_INFO("#");
                    unsigned int max_block = currentBlock;
                    unsigned int max_size = 0;
                    //Busco el mayor
                    for(std::set<int>::iterator it = arbol[currentBlock].begin(); it != arbol[currentBlock].end(); it++){
                        if(*it != currentBlock && blocks[*it].l.size() > max_size){
                            max_block = *it;
                            max_size = blocks[*it].l.size();
                        }
                    }
                    if(max_block == currentBlock) continue;
                    //Añado los puntos
                    for(std::vector<std::pair<int,int> >::iterator it = blocks[currentBlock].l.begin(); it != blocks[currentBlock].l.end(); it++){
                        corresp[*it] = max_block;
                        //blocks[max_block].l.push_back(*it);
                    }
                    //Elimino las referencias y añado nueva
                    //ROS_INFO("IN");
                    for(std::set<int>::iterator it = arbol[currentBlock].begin(); it != arbol[currentBlock].end(); it++){
                        if(*it == max_block) continue;

                        if(arbol[*it].find(currentBlock) == arbol[*it].end()){
                            //ROS_INFO("MAL: %d %d [%d]", currentBlock, *it, max_block);
                        }else{
                            arbol[*it].erase(arbol[*it].find(currentBlock));
                        }
                        arbol[*it].insert(max_block);
                        arbol[max_block].insert(*it);
                    }
                    //ROS_INFO("OUT");
                    //Añado vecinos a nuevo bloque
                    
                    blocks[max_block].l.insert(
                        blocks[max_block].l.end(),
                        blocks[i].l.begin(),
                        blocks[i].l.end());
                    
                    blocks[i].l.clear();
                    arbol[max_block].erase(arbol[max_block].find(currentBlock));
                }
            }
            //ROS_INFO("DONE ELiminar");
            //Calcular punto medio
            ROS_INFO("Calculando valor promedio");
            for(std::vector<Block>::iterator it=blocks.begin();it!=blocks.end();it++){
                if(it->l.size() > 0)
                    calcAverage(*it);
            }

            /*
                Pintar new border
            */
           ROS_INFO("Imprimiendo newBorderMap.pgm a .ros path");
            std::vector<std::vector<int> > newBorderMap(cellsY, std::vector<int>(cellsX,-1));
            int i=0;
            for(std::vector<Block>::iterator it=blocks.begin();it!=blocks.end();it++,i++){
                for(std::vector<std::pair<int,int> >::iterator mit = it->l.begin(); mit != it->l.end(); mit++){
                    newBorderMap[mit->first][mit->second] = i;
                }
            }
            
            for(int y=0; y<cellsY-1; y++){
                for(int x=0; x<cellsX-1; x++){
                    interMap[y][x] = newBorderMap[y][x];
                }
            }

            for(int y=0; y<cellsY-1; y++){
                for(int x=0; x<cellsX-1; x++){
                    if(interMap[y][x] != -1){
                        int val = interMap[y][x];
                        for(int i=0; i<=1; i++){
                            for(int j=0; j<=1; j++){
                                if((i!=0 || j!=0) && (interMap[y+i][x+j] != val) && (interMap[y+i][x+j] != -1)){
                                    int neighVal = interMap[y+i][x+j];
                                    newBorderMap[y][x] = 1000;
                                }
                            }
                        }
                    }
                }
            }
            for(std::vector<Block>::iterator it=blocks.begin();it!=blocks.end();it++){
                std::pair<int,int> av = it->average;
                newBorderMap[av.first][av.second] = 10000;
            }
            paintMap(newBorderMap,"newBorderMap.pgm");
        }

        void calcAverage(Block & b){
            int y = 0, x= 0, c=0;
            
            for(std::vector<std::pair<int,int> >::iterator it = b.l.begin(); it!= b.l.end(); it++){
                y += it->first;
                x += it->second;
                c += costMap[it->first*cellsX + it->second];
            }
            b.average.first = y/b.l.size();
            b.average.second = x/b.l.size();
            b.avCost = c/b.l.size();
            
           //b.average = b.l[b.l.size()/2];
        }

        void paintMap(std::vector<std::vector<int> > & m, const char * s){
            std::ofstream f(s,std::ios_base::out
                              |std::ios_base::trunc
                   );

            int maxColorValue = maxn+100;
            int height = m.size();
            int width = m[0].size();
            f << "P2\n" << width << " " << height << "\n" << maxColorValue << "\n";
            

            for(int i=0;i<height;++i){
                   for(int j=0; j<width; j++)
                        f << ((m[i][j]==-1)?0:(m[i][j]+100)) << " ";
                    f << "\n";
            }

            f << std::flush;
        }
            
    };
}
#endif