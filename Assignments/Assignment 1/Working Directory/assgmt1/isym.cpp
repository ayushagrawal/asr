#include<iostream>
#include<fstream>
#include<string>

using namespace std;

int main()
{
	string line;
	string word;
	int i = 1;
	ifstream words("dev.txt");
	ofstream isym;
	isym.open("isyms.txt");
	isym << "<epsilon> 0"<<'\n';
	while(getline(words,line))
	{
		//cout<<line<<'\n';
		word = line.substr(line.find("	")+1);
		isym << word.substr(word.find("	")+1) << " "<< i <<'\n';
		i = i + 1;
	}
	isym.close();
	words.close();
	return 0;
}
