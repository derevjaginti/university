#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

int const MAX = 10001;

int main()
{
	ifstream in("input.txt");
	ofstream out("output.txt");

	int n;
	int a[202][202];

	in >> n;
	for (int i = 1; i <= n; i++)
	{
		for (int j = 1; j <= n; j++) in >> a[i][j];
	}

	vector<int> u(n + 1), v(n + 1), p(n + 1), way(n + 1);

	for (int i = 1; i <= n; i++) 
	{
		p[0] = i;
		int j0 = 0;
		vector<int> minv(n + 1, MAX);
		vector<bool> used(n + 1, false);
		do
		{
			used[j0] = true;
			int i0 = p[j0], delta = MAX, j1;
			for (int j = 1; j <= n; j++)
			{
				if (!used[j])
				{
					int cur = a[i0][j] - u[i0] - v[j];
					if (cur < minv[j])
					{
						minv[j] = cur;
						way[j] = j0;
					}
					if (minv[j] < delta)
					{
						delta = minv[j];
						j1 = j;
					}
				}
			}
			for (int j = 0; j <= n; j++)
			{
				if (used[j])
				{
					u[p[j]] += delta;
					v[j] -= delta;
				}
				else minv[j] -= delta;
			}
			j0 = j1;
		} while (p[j0] != 0);
		do 
		{
			int j1 = way[j0];
			p[j0] = p[j1];
			j0 = j1;
		} while (j0);
	}

	int ans[202];
	for (int i = 1; i <= n; i++)
		ans[p[i]] = i;

	out << -v[0] << endl;

	for (int i = 1; i <= n; i++)
		out << ans[i] << " ";

	return 0;

}