CC=gcc
CXX=g++
CFLAGS=-g -c -O2 -m64 -Wall -Wfatal-errors -funroll-loops -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-function
SRC=./source
INC=-I./include
OBJS=crc.o tsdecode.o fgetopt.o mempool.o transvideo.o transaudio.o dataqueue.o udpsource.o tsreceive.o hlsmux.o mp4core.o background.o cJSON.o cJSON_Utils.o webdav.o esignal.o
LIB=libfillet.a
BASELIBS=

#ENABLE_TRANSCODE=1

ifdef ENABLE_TRANSCODE
        ifneq ("$(wildcard ./cbfdkaac/.libs/libfdk-aac.a)","")
	    FILE_EXISTS = 1
	else
	    FILE_EXISTS = 0
	    $(error Please make sure FDK-AAC is installed - missing ./cbfdkaac/.libs/libfdk-aac.a - please run setuptranscode.sh)
	endif

	CFLAGS += -DENABLE_TRANSCODE
	BASELIBS += ./cbffmpeg/libavfilter/libavfilter.a \
                    ./cbffmpeg/libavformat/libavformat.a \
		    ./cbffmpeg/libswscale/libswscale.a \
		    ./cbffmpeg/libavcodec/libavcodec.a \
	      	    ./cbffmpeg/libavutil/libavutil.a \
		    ./cbffmpeg/libavresample/libavresample.a \
		    ./cbffmpeg/libswresample/libswresample.a \
                    ./cbx264/libx264.a \
                    ./cbfdkaac/.libs/libfdk-aac.a \
                    ./cblibcurl/./lib/.libs/libcurl.a \
	            ./x265_3.0/build/linux/libx265.a
	INC += -I./cbfdkaac/libAACenc/include -I./cbfdkaac/libSYS/include
	INC += -I./x265_3.0/build/linux
	INC += -I./cblibcurl/include/curl
	INC += -I./cbffmpeg
	BASELIBS += -lz -ldl -lnuma -lcrypto -lssl
endif

all: $(LIB) fillet

fillet: fillet.o $(OBJS)
	$(CXX) fillet.o $(OBJS) -L./ $(BASELIBS) -lm -lpthread -o fillet

$(LIB): $(OBJS)
	ar rcs $(LIB) $(OBJS)
	@echo finishing building lib

fillet.o: $(SRC)/fillet.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/fillet.c

background.o: $(SRC)/background.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/background.c

tsreceive.o: $(SRC)/tsreceive.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/tsreceive.c

udpsource.o: $(SRC)/udpsource.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/udpsource.c

dataqueue.o: $(SRC)/dataqueue.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/dataqueue.c

mempool.o: $(SRC)/mempool.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/mempool.c

mp4core.o: $(SRC)/mp4core.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/mp4core.c

hlsmux.o: $(SRC)/hlsmux.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/hlsmux.c

fgetopt.o: $(SRC)/fgetopt.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/fgetopt.c

transvideo.o: $(SRC)/transvideo.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/transvideo.c

transaudio.o: $(SRC)/transaudio.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/transaudio.c

tsdecode.o: $(SRC)/tsdecode.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/tsdecode.c

webdav.o: $(SRC)/webdav.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/webdav.c

esignal.o: $(SRC)/esignal.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/esignal.c

crc.o: $(SRC)/crc.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/crc.c

cJSON.o: $(SRC)/cJSON.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/cJSON.c

cJSON_Utils.o: $(SRC)/cJSON_Utils.c
	$(CC) $(CFLAGS) $(INC) $(SRC)/cJSON_Utils.c

clean:
	rm -rf *o fillet
