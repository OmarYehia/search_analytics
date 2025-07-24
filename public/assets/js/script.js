let topTermsChart = null;
let searchTrendsChart = null;
let topUsersChart = null;

document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("searchInput");
    let debounceTimeout = null;

    searchInput.addEventListener("input", () => {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => {
            const content = searchInput.value.trim();
            if (content.length > 0) {
                submitSearch(content);
            }
        }, 500);
    });

    refreshCharts();
    setInterval(refreshCharts, 1000); // Poll every second - Simulating real-time without web sockets 
});

function submitSearch(content) {
    fetch("/api/v1/search_terms", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content })
    }).catch(console.error); // Can be handled better with Toast
}

function refreshCharts() {
    loadTopTermsChart();
    loadTrendsChart();
    loadTopUsersChart();
}

function loadTopTermsChart() {
    fetch("/api/v1/search_analytics/top_terms")
        .then(res => res.json())
        .then(data => {
            const labels = Object.keys(data);
            const values = Object.values(data);

            if (topTermsChart) topTermsChart.destroy();
            topTermsChart = new Chart(document.getElementById("topTermsChart"), {
                type: "bar",
                data: {
                    labels,
                    datasets: [{
                        label: "Searches",
                        data: values,
                        backgroundColor: "#4e79a7"
                    }]
                },
                options: { responsive: true, scales: { y: { beginAtZero: true } }, animation: false }
            });
        });
}

function loadTrendsChart() {
    fetch("/api/v1/search_analytics/trends")
        .then(res => res.json())
        .then(data => {
            const labels = Object.keys(data);
            const values = Object.values(data);

            if (searchTrendsChart) searchTrendsChart.destroy();
            searchTrendsChart = new Chart(document.getElementById("searchTrendsChart"), {
                type: "line",
                data: {
                    labels,
                    datasets: [{
                        label: "Searches per Day",
                        data: values,
                        borderColor: "#59a14f",
                        fill: false,
                        tension: 0.2
                    }]
                },
                options: { responsive: true, animation: false }
            });
        });
}

function loadTopUsersChart() {
    fetch("/api/v1/search_analytics/user_activity")
        .then(res => res.json())
        .then(data => {
            const labels = Object.keys(data);
            const values = Object.values(data);
            const colors = generateColors(values.length);

            if (topUsersChart) topUsersChart.destroy();
            topUsersChart = new Chart(document.getElementById("topUsersChart"), {
                type: "pie",
                data: {
                    labels,
                    datasets: [{
                        label: "Searches",
                        data: values,
                        backgroundColor: colors
                    }]
                },
                options: { responsive: true, animation: false }
            });
        });
}

function generateColors(n) {
    const colors = [];
    for (let i = 0; i < n; i++) {
        const hue = (360 * i) / n;
        colors.push(`hsl(${hue}, 70%, 60%)`);
    }
    return colors;
}