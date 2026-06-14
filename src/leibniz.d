import std.stdio;
import std.file;
import std.conv;

void main() {
    auto content = readText("./rounds.txt");
    uint rounds = to!uint(content.strip);

    rounds += 2u;

    double pi = 1.0;

    foreach (i; 2u .. rounds) {
        double x = ((i & 1) == 0) ? -1.0 : 1.0;
        pi += x / (2.0 * i - 1.0);
    }

    pi *= 4.0;
    writefln("%.16f", pi);
}