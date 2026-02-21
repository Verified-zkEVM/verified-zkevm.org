document.addEventListener('DOMContentLoaded', () => {
    loadMarkdown('data/overview.md', 'overview-content');
    loadTracks();
    loadMarkdown('data/rfps.md', 'rfps-content');
    loadMarkdown('data/applications.md', 'applications-content');
    loadMarkdown('data/contact.md', 'contact-content');
    loadGithubActivity();
    loadGrants();
    loadMedia();
    setupMobileMenu();
    setupScrollSpy();
});

async function loadMarkdown(url, elementId) {
    try {
        const response = await fetch(url);
        const text = await response.text();
        const container = document.getElementById(elementId);
        if (container) {
            container.innerHTML = marked.parse(text);
        }
    } catch (error) {
        console.error(`Error loading markdown from ${url}:`, error);
    }
}

async function loadTracks() {
    try {
        const response = await fetch('data/tracks.json');
        const data = await response.json();
        const container = document.getElementById('tracks-container');

        if (!container) return;

        data.forEach(track => {
            const trackSection = document.createElement('div');
            trackSection.className = 'card track-card';
            trackSection.innerHTML = `
                <h3>${track.title}</h3>
                <p>${track.description}</p>
            `;
            container.appendChild(trackSection);
        });
    } catch (error) {
        console.error('Error loading tracks:', error);
        const container = document.getElementById('tracks-container');
        if (container) {
            container.innerHTML = '<div class="alert-box">Failed to load tracks data. Please try again later.</div>';
        }
    }
}

async function loadGrants() {
    try {
        const response = await fetch('data/grants.json');
        const data = await response.json();
        const container = document.getElementById('grants-container');

        if (!container) return;

        data.forEach(track => {
            const trackSection = document.createElement('div');
            trackSection.className = 'track-section';

            const trackTitle = document.createElement('h3');
            trackTitle.textContent = track.track;
            trackSection.appendChild(trackTitle);

            const list = document.createElement('ul');
            list.className = 'grant-list';

            track.items.forEach(item => {
                const li = document.createElement('li');
                li.className = 'grant-item';
                const periodHtml = item.period ? `<p class="grant-period"><strong>Period:</strong> ${item.period}</p>` : '';
                li.innerHTML = `
                    <h4>${item.title}</h4>
                    <p>${item.description}</p>
                    <div class="grant-meta">
                        <p class="awarded-to"><strong>Awarded to:</strong> ${item.awardedTo}</p>
                        ${periodHtml}
                    </div>
                `;
                list.appendChild(li);
            });

            trackSection.appendChild(list);

            // Add divider if not the last item
            if (data.indexOf(track) < data.length - 1) {
                const divider = document.createElement('div');
                divider.className = 'subsection-divider';
                trackSection.appendChild(divider);
            }

            container.appendChild(trackSection);
        });
    } catch (error) {
        console.error('Error loading grants:', error);
        const container = document.getElementById('grants-container');
        if (container) {
            container.innerHTML = '<div class="alert-box">Failed to load grants data.</div>';
        }
    }
}

async function loadMedia() {
    try {
        const response = await fetch('data/media.json');
        const data = await response.json();
        const container = document.getElementById('media-container');

        if (!container) return;

        data.forEach(category => {
            const categorySection = document.createElement('div');

            const categoryTitle = document.createElement('h3');
            categoryTitle.textContent = category.category;
            categorySection.appendChild(categoryTitle);

            // Special handling for Video Updates
            if (category.category.includes('Video')) {
                const grid = document.createElement('div');
                grid.className = 'video-grid';

                category.items.forEach(item => {
                    const videoId = getYouTubeVideoId(item.url);
                    const thumbnailUrl = videoId ?
                        `https://img.youtube.com/vi/${videoId}/mqdefault.jpg` :
                        'eth-diamond-multi.png'; // Fallback

                    const card = document.createElement('a');
                    card.href = item.url;
                    card.target = '_blank';
                    card.className = 'video-card';
                    card.innerHTML = `
                        <div class="video-thumbnail">
                            <img src="${thumbnailUrl}" alt="${item.title}" loading="lazy">
                            <div class="play-icon">▶</div>
                        </div>
                        <div class="video-info">
                            <h4>${item.title}</h4>
                        </div>
                    `;
                    grid.appendChild(card);
                });
                categorySection.appendChild(grid);
            } else {
                // Standard list for other categories
                const list = document.createElement('ul');
                list.className = 'media-list';

                category.items.forEach(item => {
                    const li = document.createElement('li');
                    li.innerHTML = `<a href="${item.url}" target="_blank">${item.title}</a>`;
                    list.appendChild(li);
                });
                categorySection.appendChild(list);
            }

            container.appendChild(categorySection);
        });
    } catch (error) {
        console.error('Error loading media:', error);
        const container = document.getElementById('media-container');
        if (container) {
            container.innerHTML = '<p>Failed to load media resources.</p>';
        }
    }
}

function getYouTubeVideoId(url) {
    try {
        const urlObj = new URL(url);
        if (urlObj.hostname.includes('youtube.com')) {
            return urlObj.searchParams.get('v');
        } else if (urlObj.hostname.includes('youtu.be')) {
            return urlObj.pathname.slice(1);
        }
    } catch (e) {
        console.warn('Invalid YouTube URL:', url);
    }
    return null;
}

function setupMobileMenu() {
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.querySelector('.sidebar');

    if (menuToggle && sidebar) {
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('active');
            menuToggle.classList.toggle('active');
        });

        // Close menu when clicking a link
        sidebar.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                sidebar.classList.remove('active');
                menuToggle.classList.remove('active');
            });
        });
    }
}

function setupScrollSpy() {
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('.nav-link');

    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.3 // Trigger when 30% of the section is visible
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.getAttribute('id');

                // Remove active class from all links
                navLinks.forEach(link => link.classList.remove('active'));

                // Add active class to corresponding link
                const activeLink = document.querySelector(`.nav-link[href="#${id}"]`);
                if (activeLink) {
                    activeLink.classList.add('active');
                }
            }
        });
    }, observerOptions);

    sections.forEach(section => {
        observer.observe(section);
    });
}

async function loadGithubActivity() {
    const container = document.getElementById('activity-container');
    if (!container) return;

    const CACHE_KEY = 'github_activity_cache';
    const CACHE_DURATION = 15 * 60 * 1000; // 15 minutes

    // Check cache
    const cached = localStorage.getItem(CACHE_KEY);
    if (cached) {
        const { timestamp, data } = JSON.parse(cached);
        if (Date.now() - timestamp < CACHE_DURATION) {
            renderActivity(data, container);
            return;
        }
    }

    try {
        const response = await fetch('data/repos.json');
        const repos = await response.json();

        // Fetch events for each repo in parallel
        const fetchPromises = repos.map(async repo => {
            try {
                const eventsResponse = await fetch(`https://api.github.com/repos/${repo}/events?per_page=30`);
                if (eventsResponse.ok) {
                    return await eventsResponse.json();
                }
                return [];
            } catch (e) {
                console.warn(`Failed to fetch events for ${repo}`, e);
                return [];
            }
        });

        const results = await Promise.all(fetchPromises);
        const allEvents = results.flat();

        const meaningfulEvents = allEvents.filter(event => {
            switch (event.type) {
                case 'PushEvent':
                    return event.payload.ref === 'refs/heads/main' || event.payload.ref === 'refs/heads/master';
                case 'PullRequestEvent':
                    return event.payload.action === 'opened' || event.payload.action === 'merged' || (event.payload.action === 'closed' && event.payload.pull_request.merged);
                case 'ReleaseEvent':
                    return event.payload.action === 'published';
                case 'GollumEvent':
                    return true;
                case 'IssuesEvent':
                    return event.payload.action === 'opened' || event.payload.action === 'closed';
                case 'DiscussionEvent':
                    return event.payload.action === 'created';
                case 'PullRequestReviewEvent':
                    return event.payload.action === 'created';
                default:
                    return false;
            }
        });

        // Sort by date (newest first)
        meaningfulEvents.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));

        // Keep top 10
        const topEvents = meaningfulEvents.slice(0, 10);

        // Cache result
        localStorage.setItem(CACHE_KEY, JSON.stringify({
            timestamp: Date.now(),
            data: topEvents
        }));

        renderActivity(topEvents, container);

    } catch (error) {
        console.error('Error loading GitHub activity:', error);
        container.innerHTML = '<p>Unable to load activity feed. Please check back later.</p>';
    }
}

function renderActivity(events, container) {
    if (events.length === 0) {
        container.innerHTML = '<p>No recent activity found.</p>';
        return;
    }

    const list = document.createElement('ul');
    list.className = 'activity-list';

    events.forEach(event => {
        const li = document.createElement('li');
        li.className = 'activity-item';

        let action = '';
        let details = '';
        const repoName = event.repo.name;
        const date = new Date(event.created_at).toLocaleDateString();

        switch (event.type) {
            case 'PushEvent':
                action = 'pushed to';
                details = `branch <code>${event.payload.ref.replace('refs/heads/', '')}</code>`;
                break;
            case 'PullRequestEvent':
                const prAction = (event.payload.action === 'merged' || (event.payload.action === 'closed' && event.payload.pull_request.merged)) ? 'merged' : 'opened';
                action = `${prAction} PR #${event.payload.number}`;
                details = `<a href="${event.payload.pull_request.html_url}" target="_blank">${event.payload.pull_request.title}</a>`;
                break;
            case 'IssuesEvent':
                action = `${event.payload.action} issue #${event.payload.issue.number}`;
                details = `<a href="${event.payload.issue.html_url}" target="_blank">${event.payload.issue.title}</a>`;
                break;
            case 'ReleaseEvent':
                action = `published release`;
                details = `<a href="${event.payload.release.html_url}" target="_blank">${event.payload.release.name || event.payload.release.tag_name}</a>`;
                break;
            case 'DiscussionEvent':
                action = `${event.payload.action} discussion`;
                details = `<a href="${event.payload.discussion.html_url}" target="_blank">${event.payload.discussion.title}</a>`;
                break;
            case 'GollumEvent':
                const page = event.payload.pages[0];
                action = `${page.action} wiki page`;
                details = `<a href="${page.html_url}" target="_blank">${page.title}</a>`;
                break;
            case 'PullRequestReviewEvent':
                action = `reviewed PR #${event.payload.pull_request.number}`;
                details = `<a href="${event.payload.review.html_url}" target="_blank">${event.payload.pull_request.title}</a>`;
                break;
            default:
                action = 'acted on';
                details = event.type;
        }

        li.innerHTML = `
            <div class="activity-header">
                <span class="activity-repo">${repoName}</span>
                <span class="activity-date">${date}</span>
            </div>
            <div class="activity-body">
                <strong>${event.actor.login}</strong> ${action} ${details}
            </div>
        `;
        list.appendChild(li);
    });

    container.innerHTML = '';
    container.appendChild(list);
}
