
CC = arm-linux-g++
CFLAGS = -Wall -ansi -g -std=c++11

OBJS = zed_app.o Board.o Timer.o

#set up C suffixes & relationship between .cpp and .o files
.SUFFIXES: .cpp

.cpp.o:
	$(CC) $(CFLAGS) -c $<


fabric: $(OBJS)
	${CC} -o zed_app $(OBJS)

zed_app.o : Board.h Timer.h
Board.o : Board.h

clean:
	rm -f *.o *~ zed_app

# DO NOT DELETE
