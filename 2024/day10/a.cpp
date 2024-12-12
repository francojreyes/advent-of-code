#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
typedef pair<int,int> ii;
typedef tuple<int,int,int> iii;

const int dx[4] = { -1, 0, 1, 0 };
const int dy[4] = { 0, 1, 0, -1 };

template<typename A, typename B> ostream& operator<<(ostream &os, const pair<A, B> &p) { return os << '(' << p.first << ", " << p.second << ')'; }
template<typename T_container, typename T = typename enable_if<!is_same<T_container, string>::value, typename T_container::value_type>::type> ostream& operator<<(ostream &os, const T_container &v) { os << '{'; string sep; for (const T &x : v) os << sep << x, sep = ", "; return os << '}'; }

struct chash {
	static uint64_t splitmix64(uint64_t x) {
		// http://xorshift.di.unimi.it/splitmix64.c
		x += 0x9e3779b97f4a7c15;
		x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
		x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
		return x ^ (x >> 31);
	}

	size_t operator()(uint64_t x) const {
		static const uint64_t FIXED_RANDOM = chrono::steady_clock::now().time_since_epoch().count();
		return splitmix64(x + FIXED_RANDOM);
	}
};

const ll MOD = 1e9 + 7;
inline ll mod(ll x, ll m = MOD) {
	return ((x % m) + m) % m;
}

const int N = 200100;
int n;

int toId(int i, int j, int d) {
    return (i * n + j) * 4 + d;
}

bool valid(ii pos) {
    return pos.first >= 0 && pos.first < n && pos.second >= 0 && pos.second < n;
}

int main(void) {
	cin.tie(nullptr);
	cin.sync_with_stdio(false);

    vector<string> grid;
    string s;
    while (getline(cin, s)) {
        grid.push_back(s);
    }
    n = grid.size();

    ii src;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == '^') src = {i, j};
        }
    }

    int obst = 0;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == '#') continue;
            grid[i][j] = '#';

            ii curr = src;
            int d = 0;
            unordered_set<int> seen;
            while (true) {
                if (seen.count(toId(curr.first, curr.second, d))) {
                    obst++;
                    break;
                }

                seen.insert(toId(curr.first, curr.second, d));
                ii next = curr;
                next.first += dx[d];
                next.second += dy[d];

                if (!valid(next)) break;
                if (grid[next.first][next.second] == '#') {
                    d = (d + 1) % 4;
                } else {
                    curr = next;
                }
            }

            grid[i][j] = '.';
        }
    }

    cout << obst << endl;
}
