#include <iostream>

using namespace std;

extern int PrintN(void);

int main(int argc, char** argv){
	int n = PrintN();
	cout << n  << endl;
	return 0;
}
