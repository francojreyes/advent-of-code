#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
typedef tuple<ll,ll,ll> iii;

const int N = 1010;

int parent[N];
ll subtree_size[N];

void init(int n) {
    for (int i = 0; i < n; i++) {
        parent[i] = i;
        subtree_size[i] = 1;
    }
}

int root(int x) {
    return parent[x] == x ? x : parent[x] = root(parent[x]);
}

bool join(int x, int y) {
    x = root(x); y = root(y);
    if (x == y) return false;
    if (subtree_size[x] < subtree_size[y]) {
        parent[x] = y;
        subtree_size[y] += subtree_size[x];
    } else {
        parent[y] = x;
        subtree_size[x] += subtree_size[y];
    }
    return true;
}

iii pts[N];

ll sq_dist(iii a, iii b) {
    ll dx = get<0>(a) - get<0>(b);
    ll dy = get<1>(a) - get<1>(b);
    ll dz = get<2>(a) - get<2>(b);
    return dx * dx + dy * dy + dz * dz;
}

int main() {
    int n = 0;
    while (scanf("%lld,%lld,%lld", &get<0>(pts[n]), &get<1>(pts[n]), &get<2>(pts[n])) == 3)
        n++;

    priority_queue<iii, vector<iii>, greater<>> pq;
    for (int i = 0; i < n; i++)
        for (int j = i + 1; j < n; j++)
            pq.emplace(sq_dist(pts[i], pts[j]), i, j);

    init(n);
    int joins = 0;
    while (!pq.empty()) {
        auto [d, x, y] = pq.top();
        pq.pop();

        if (join(x, y))
            if (++joins == n - 1)
                cout << get<0>(pts[x]) * get<0>(pts[y]) << endl;
    }
}
