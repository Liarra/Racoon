# This is a fairly standard GNU Makefile that should work
# for Linux and maybe Windows with some small modifications.

CC = gcc
FLAGS = -O3 -std=c99 -pedantic -g \
        -Werror=return-type -Werror=uninitialized -Wall

LNK = -L./
INC = -I./

COMP = $(CC) $(FLAGS) $(INC)
LINK = $(CC) $(FLAGS) $(INC) $(LNK)

EXE = a.out
EXT = c
SRC = $(wildcard *.$(EXT))

# For windows:
#MAKE_DIR = $(if exist $(1),,mkdir $(1))
#S=\\
# Linux and Unix-like:
MAKE_DIR = mkdir -p $(1)
S=/



OBJ_DIR = obj
OBJ = $(SRC:%.$(EXT)=$(OBJ_DIR)$(S)%.o)
OBJ_DIRS = $(dir $(OBJ))
DEPS = $(OBJ:%.o=%.d)

.PHONY: dirs all help clean

all : dirs $(EXE)

dirs : $(OBJ_DIR)

$(OBJ_DIR) :
	$(call $(MAKE_DIR),$@)

help :
	@echo "SRC is $(SRC)"
	@echo "OBJ is $(OBJ)"
	@echo "DEPS is $(DEPS)"

$(EXE) : $(OBJ)
	$(LINK) $(OBJ) -o $@

$(OBJ_DIR)$(S)%.o : %.$(EXT)
	$(call MAKE_DIR,$(dir $@))
	$(COMP) -c $< -o $@
	$(COMP) -M -MT '$@' $< -MF $(@:%.o=%.d)

clean:
	rm -r $(OBJ_DIR)
	rm -f $(EXE)

-include $(DEPS)
