const app = document.getElementById('app');
const container = document.querySelector('.bm');
const headerTitle = document.getElementById('headerTitle');
const headerName = document.getElementById('headerName');
const balanceEl = document.getElementById('balance');
const closeBtn = document.getElementById('closeBtn');
const tabsContainer = document.getElementById('tabsContainer');
const searchInput = document.getElementById('searchInput');
const itemsList = document.getElementById('itemsList');
const detailPanel = document.getElementById('detailPanel');
const detailImg = document.getElementById('detailImg');
const detailName = document.getElementById('detailName');
const detailDesc = document.getElementById('detailDesc');
const detailPrice = document.getElementById('detailPrice');
const detailStock = document.getElementById('detailStock');
const detailTotal = document.getElementById('detailTotal');
const qtyInput = document.getElementById('qtyInput');
const qtyMinus = document.getElementById('qtyMinus');
const qtyPlus = document.getElementById('qtyPlus');
const footerTotal = document.getElementById('footerTotal');
const buyBtn = document.getElementById('buyBtn');
const buyBtnText = document.getElementById('buyBtnText');
const notification = document.getElementById('notification');
const notifText = document.getElementById('notifText');
const labelPrice = document.getElementById('labelPrice');
const labelStock = document.getElementById('labelStock');
const labelQty = document.getElementById('labelQty');
const labelTotal = document.getElementById('labelTotal');
const footerTotalLabel = document.getElementById('footerTotalLabel');

let categories = [];
let allItems = [];
let filteredItems = [];
let selectedItem = null;
let activeTab = 'all';
let locales = {};
let notifTimeout = null;
let isClosing = false;

function formatPrice(num) {
    return num.toLocaleString('da-DK') + ' kr';
}

function getItemImage(itemName) {
    return 'nui://ox_inventory/web/images/' + itemName.toLowerCase() + '.png';
}

function buildAllItems() {
    allItems = [];
    categories.forEach(cat => {
        cat.items.forEach(item => {
            allItems.push({ ...item, category: cat.label, categoryId: cat.id });
        });
    });
}

function renderTabs() {
    tabsContainer.innerHTML = '';
    const allTab = document.createElement('div');
    allTab.className = 'bm-tab active';
    allTab.textContent = locales.all || 'Alle';
    allTab.dataset.id = 'all';
    allTab.addEventListener('click', () => selectTab('all'));
    tabsContainer.appendChild(allTab);

    categories.forEach(cat => {
        const tab = document.createElement('div');
        tab.className = 'bm-tab';
        tab.textContent = cat.label;
        tab.dataset.id = cat.id;
        tab.addEventListener('click', () => selectTab(cat.id));
        tabsContainer.appendChild(tab);
    });
}

function selectTab(tabId) {
    activeTab = tabId;
    document.querySelectorAll('.bm-tab').forEach(t => {
        t.classList.toggle('active', t.dataset.id === tabId);
    });
    filterItems();
}

function filterItems() {
    const query = searchInput.value.toLowerCase().trim();
    filteredItems = allItems.filter(item => {
        const matchTab = activeTab === 'all' || item.categoryId === activeTab;
        const matchSearch = !query || item.label.toLowerCase().includes(query) || item.category.toLowerCase().includes(query);
        return matchTab && matchSearch;
    });
    renderItems();
}

function renderItems() {
    itemsList.innerHTML = '';
    filteredItems.forEach(item => {
        const el = document.createElement('div');
        el.className = 'bm-item' + (selectedItem && selectedItem.name === item.name ? ' active' : '');
        el.innerHTML = `
            <div class="bm-item-img">
                <img src="${getItemImage(item.name)}" onerror="this.style.display='none'" alt="">
            </div>
            <div class="bm-item-info">
                <div class="bm-item-name">${item.label}</div>
                <div class="bm-item-cat">${item.category}</div>
            </div>
            <div class="bm-item-price">${formatPrice(item.price)}</div>
        `;
        el.addEventListener('click', () => selectItem(item));
        itemsList.appendChild(el);
    });
}

function selectItem(item) {
    selectedItem = item;
    qtyInput.value = 1;

    detailImg.src = getItemImage(item.name);
    detailImg.onerror = function() { this.style.display = 'none'; };
    detailImg.onload = function() { this.style.display = 'block'; };
    detailName.textContent = item.label;
    detailDesc.textContent = item.description;
    detailPrice.textContent = formatPrice(item.price);
    detailStock.textContent = item.stock === -1 ? '\u221E' : item.stock;
    updateTotal();

    detailPanel.classList.remove('hidden');
    detailPanel.style.animation = 'none';
    detailPanel.offsetHeight;
    detailPanel.style.animation = 'detailFade 0.25s ease';

    renderItems();
}

function updateTotal() {
    if (!selectedItem) return;
    const qty = parseInt(qtyInput.value) || 1;
    const total = selectedItem.price * qty;
    detailTotal.textContent = formatPrice(total);
    footerTotal.textContent = formatPrice(total);
}

function showNotif(message, type) {
    if (notifTimeout) clearTimeout(notifTimeout);
    notification.className = 'bm-notif ' + type;
    notifText.textContent = message;
    notifTimeout = setTimeout(() => {
        notification.className = 'bm-notif hidden';
    }, 3000);
}

function applyLocales() {
    headerTitle.textContent = locales.title || 'BLACK MARKET';
    searchInput.placeholder = locales.search || 'Search...';
    labelPrice.textContent = locales.price || 'Price';
    labelStock.textContent = locales.stock || 'Stock';
    labelQty.textContent = locales.quantity || 'Qty';
    labelTotal.textContent = locales.total || 'Total:';
    footerTotalLabel.textContent = locales.total || 'Total:';
    buyBtnText.textContent = locales.add_to_cart || 'ADD TO CART';
}

function closeUI() {
    if (isClosing) return;
    isClosing = true;
    container.style.animation = 'slideOut 0.25s cubic-bezier(0.4, 0, 1, 1) forwards';
    app.style.animation = 'fadeOut 0.25s ease forwards';
    setTimeout(() => {
        app.classList.add('hidden');
        container.style.animation = '';
        app.style.animation = '';
        isClosing = false;
        selectedItem = null;
        detailPanel.classList.add('hidden');
        fetch('https://benny_blackmarket/close', { method: 'POST', body: JSON.stringify({}) });
    }, 230);
}

closeBtn.addEventListener('click', closeUI);

searchInput.addEventListener('input', filterItems);

qtyMinus.addEventListener('click', () => {
    const v = parseInt(qtyInput.value) || 1;
    if (v > 1) qtyInput.value = v - 1;
    updateTotal();
});

qtyPlus.addEventListener('click', () => {
    const v = parseInt(qtyInput.value) || 1;
    if (v < 99) qtyInput.value = v + 1;
    updateTotal();
});

qtyInput.addEventListener('input', () => {
    let v = parseInt(qtyInput.value);
    if (isNaN(v) || v < 1) v = 1;
    if (v > 99) v = 99;
    qtyInput.value = v;
    updateTotal();
});

buyBtn.addEventListener('click', () => {
    if (!selectedItem) return;
    const qty = parseInt(qtyInput.value) || 1;

    buyBtn.disabled = true;
    buyBtnText.textContent = locales.adding || 'ADDING...';

    fetch('https://benny_blackmarket/purchase', {
        method: 'POST',
        body: JSON.stringify({ item: selectedItem.name, amount: qty }),
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            showNotif(data.message, 'success');
            if (data.newBalance !== undefined) {
                balanceEl.textContent = formatPrice(data.newBalance);
            }
        } else {
            showNotif(data.message || locales.purchase_failed || 'Failed', 'error');
        }
    })
    .catch(() => {
        showNotif(locales.something_wrong || 'Error', 'error');
    })
    .finally(() => {
        buyBtn.disabled = false;
        buyBtnText.textContent = locales.add_to_cart || 'ADD TO CART';
    });
});

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeUI();
});

window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'open') {
        isClosing = false;
        categories = data.categories || [];
        locales = data.locales || {};
        balanceEl.textContent = formatPrice(data.currency || 0);
        headerName.textContent = data.dealerName || '';

        buildAllItems();
        applyLocales();
        renderTabs();
        activeTab = 'all';
        searchInput.value = '';
        selectedItem = null;
        detailPanel.classList.add('hidden');
        filterItems();

        app.classList.remove('hidden');
        container.style.animation = 'slideIn 0.35s cubic-bezier(0.16, 1, 0.3, 1)';
        app.style.animation = 'fadeIn 0.25s ease';
    }

    if (data.action === 'close') {
        app.classList.add('hidden');
        selectedItem = null;
    }
});
