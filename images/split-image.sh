#! /bin/bash
image_name=dolorean
convert $image_name.jpg -crop 160x120 160/$image_name-%03d.jpg
convert $image_name.jpg -crop   80x80  80/$image_name-%03d.jpg
convert $image_name.jpg -crop   40x40  40/$image_name-%03d.jpg

