#include<iostream>
#include<fstream>
#include<string>
#include<math.h>
#include<cstdlib>

using namespace std;

int main()
{
	string line;
	string word;
	int totalWords = 0;
	float prob = 0.0;
	ifstream words("wordcounts.txt"),letters("lets.vocab");
	ofstream G;
	G.open("G_init.fst");
	while(getline(words,line))
		totalWords = totalWords + 1;
	words.clear();
	words.seekg(0, words.beg);
	while(getline(words,line))
	{
		float num = atoi(line.substr(line.find(" ")).c_str())/(totalWords*1.0);
		//cout << num << '\n';
		prob = -log10(num);
		//cout<<line<<'\n';
		// 0 0 word word weight
		G << "0 0 " << line.substr(0,line.find(" ")) << " " << line.substr(0,line.find(" ")) << " " << prob << '\n';
	}
	G << "0 0" << '\n';  // As final and initial states are same
	G.close();
	return 0;
}
