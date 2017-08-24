//#include <fst/fstlib.h>
//#include <fst/fst-decl.h>
#include<iostream>
#include<fstream>
#include<string>

using namespace std;

int main()
{
	int numStates = 1;
	const int finalState = 1;
	string line;
	string word;
	ifstream words("words.vocab"),letters("lets.vocab");
	ofstream T,isym,osym;
	T.open("T_init.fst");
	isym.open("isyms.txt");
	osym.open("osyms.txt");
	isym << "<epsilon> 0"<<'\n';
	osym << "<epsilon> 0"<<'\n';
	getline(words,line);
	T << "0 0 <epsilon> <epsilon>" <<'\n';
	while(getline(words,line))
	{
		//cout<<line<<'\n';
		word = line.substr(0,line.find("	"));// TAB
		for(int i = 0; i<word.length();i++)
		{
			if(i == 0)
			{
				T << i << " " << i+1+numStates << " " << word << " " << word[i] << '\n';
			}
			else if(i == word.length()-1)
			{
				T << i+numStates << " " << finalState << " " << "<epsilon>" << " " << word[i] << '\n';
			}
			else
			{
				T << i+numStates << " " << i+1+numStates << " " << "<epsilon>" << " " << word[i] << '\n';
			}
		}
		numStates = numStates+word.length()-1;
		isym << word << " "<< line.substr(line.find("	")+1)<<'\n';
	}
	getline(letters,line);
	while(getline(letters,line))
		osym << line.substr(0,line.find("	")) << " " << line.substr(line.find("	")+1)<<'\n';
	T << finalState << " 0" << '\n';  
	isym.close();
	osym.close();
	words.close();
	letters.close();
	T.close();
	return 0;
}
