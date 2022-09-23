import("stdfaust.lib");

duplicate(1,x) = x;
duplicate(n,x) = x, duplicate(n-1,x);

count((x,xs)) = 1 + count(xs);
count(x) = 1;
process = count(duplicate(5, 3.14));
			