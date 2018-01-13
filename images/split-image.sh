#! /bin/bash
convert dino.jpg -crop 160x160 160/dino-%03d.jpg
convert dino.jpg -crop   80x80  80/dino-%03d.jpg
convert dino.jpg -crop   32x32  32/dino-%03d.jpg

