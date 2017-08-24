#include<iostream>
#include<fstream>
#include<string>

using namespace std;

int main()
{
	int i = 0;
	const int finalState = 1;
	string line;
	ifstream letters("lets.vocab");
	ofstream E;
	E.open("E_init.fst");
	string let[27];
	let[26] = "<epsilon>";
	getline(letters,line);
	while(getline(letters,line))
	{
		//cout<<line<<'\n';
		let[i] = line.substr(0,line.find("	"));
		i = i + 1;
	}
	for(i = 0; i<=26; i++)
	{
		E << "0 0" << " " << let[i] << " " << let[i] << " 0" << '\n';
		for(int j = 0; j<=26; j++)
		{
			if(j != i)
				E << "0 0 " << let[i] << " " << let[j] << " 1" << '\n';
		}
	}
	
	for(i = 0; i<26; i++)
	{
		E << "0 " << i+1 << " " << let[i] << " " << let[i] << '\n';
		E << i+1 << " " << "0 " << let[i] << " <epsilon> 0.5" << '\n';
		E << "0 " << i+27 << " " << let[i] << " " << let[i] << '\n';
		E << i+27 << " " << "0 <epsilon> " << let[i] << " 0.5" << '\n';
	}

	E << "0" << " 0" << '\n';  
	letters.close();
	E.close();
	return 0;
}
