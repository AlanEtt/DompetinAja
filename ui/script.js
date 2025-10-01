// DompetinAja - Mobile Financial App
// JavaScript functionality for the mobile-first financial management app

class DompetinAja {
    constructor() {
        this.currentSection = 'dashboard';
        this.transactions = [];
        this.wallets = [];
        this.categories = [];
        this.budgets = [];
        this.debts = [];
        this.recurringTransactions = [];
        
        this.init();
    }

    init() {
        this.loadSampleData();
        this.setupEventListeners();
        this.renderDashboard();
        this.initializeCharts();
    }

    // Sample Data
    loadSampleData() {
        // Sample Wallets
        this.wallets = [
            { id: 1, name: 'Bank BCA', balance: 1500000, icon: 'fas fa-university', color: '#3b82f6' },
            { id: 2, name: 'GoPay', balance: 250000, icon: 'fas fa-credit-card', color: '#10b981' },
            { id: 3, name: 'Tunai', balance: 700000, icon: 'fas fa-money-bill-wave', color: '#f59e0b' }
        ];

        // Sample Categories
        this.categories = [
            { id: 1, name: 'Gaji', type: 'income', icon: 'fas fa-briefcase', color: '#10b981' },
            { id: 2, name: 'Freelance', type: 'income', icon: 'fas fa-laptop', color: '#8b5cf6' },
            { id: 3, name: 'Makanan', type: 'expense', icon: 'fas fa-utensils', color: '#ef4444' },
            { id: 4, name: 'Transportasi', type: 'expense', icon: 'fas fa-car', color: '#f59e0b' },
            { id: 5, name: 'Belanja', type: 'expense', icon: 'fas fa-shopping-bag', color: '#ec4899' },
            { id: 6, name: 'Hiburan', type: 'expense', icon: 'fas fa-film', color: '#06b6d4' }
        ];

        // Sample Transactions
        this.transactions = [
            {
                id: 1,
                type: 'income',
                amount: 5000000,
                walletId: 1,
                categoryId: 1,
                description: 'Gaji bulanan',
                date: '2024-01-15',
                time: '09:00'
            },
            {
                id: 2,
                type: 'expense',
                amount: 150000,
                walletId: 2,
                categoryId: 3,
                description: 'Makan siang',
                date: '2024-01-15',
                time: '12:30'
            },
            {
                id: 3,
                type: 'expense',
                amount: 50000,
                walletId: 3,
                categoryId: 4,
                description: 'Ojek online',
                date: '2024-01-15',
                time: '14:15'
            },
            {
                id: 4,
                type: 'expense',
                amount: 300000,
                walletId: 1,
                categoryId: 5,
                description: 'Belanja bulanan',
                date: '2024-01-14',
                time: '16:45'
            },
            {
                id: 5,
                type: 'income',
                amount: 750000,
                walletId: 2,
                categoryId: 2,
                description: 'Project freelance',
                date: '2024-01-13',
                time: '20:00'
            }
        ];

        // Sample Budgets
        this.budgets = [
            { id: 1, categoryId: 3, amount: 1000000, spent: 450000, month: 1, year: 2024 },
            { id: 2, categoryId: 4, amount: 500000, spent: 200000, month: 1, year: 2024 },
            { id: 3, categoryId: 5, amount: 2000000, spent: 1800000, month: 1, year: 2024 }
        ];

        // Sample Debts
        this.debts = [
            {
                id: 1,
                personName: 'Budi Santoso',
                amount: 500000,
                type: 'debt',
                dueDate: '2024-02-01',
                isSettled: false,
                description: 'Pinjaman untuk kebutuhan mendesak'
            },
            {
                id: 2,
                personName: 'Siti Rahayu',
                amount: 750000,
                type: 'credit',
                dueDate: '2024-01-25',
                isSettled: false,
                description: 'Uang yang dipinjamkan ke teman'
            }
        ];

        // Sample Recurring Transactions
        this.recurringTransactions = [
            {
                id: 1,
                walletId: 1,
                categoryId: 1,
                amount: 5000000,
                description: 'Gaji bulanan',
                frequency: 'monthly',
                startDate: '2024-01-01',
                nextOccurrence: '2024-02-01'
            },
            {
                id: 2,
                walletId: 1,
                categoryId: 3,
                amount: 150000,
                description: 'Langganan Netflix',
                frequency: 'monthly',
                startDate: '2024-01-01',
                nextOccurrence: '2024-02-01'
            }
        ];
    }

    // Event Listeners
    setupEventListeners() {
        // Navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const section = e.currentTarget.dataset.section;
                this.navigateToSection(section);
            });
        });

        // Quick Actions
        document.getElementById('addIncomeBtn').addEventListener('click', () => {
            this.openTransactionModal('income');
        });

        document.getElementById('addExpenseBtn').addEventListener('click', () => {
            this.openTransactionModal('expense');
        });

        document.getElementById('transferBtn').addEventListener('click', () => {
            this.showNotification('Fitur transfer akan segera hadir!', 'info');
        });

        document.getElementById('budgetBtn').addEventListener('click', () => {
            this.navigateToSection('budget');
        });

        // Back buttons
        document.getElementById('backToDashboardBtn').addEventListener('click', () => {
            this.navigateToSection('dashboard');
        });

        document.getElementById('backToDashboardFromWalletsBtn').addEventListener('click', () => {
            this.navigateToSection('dashboard');
        });

        document.getElementById('backToDashboardFromBudgetBtn').addEventListener('click', () => {
            this.navigateToSection('dashboard');
        });

        document.getElementById('backToDashboardFromDebtsBtn').addEventListener('click', () => {
            this.navigateToSection('dashboard');
        });

        document.getElementById('backToDashboardFromRecurringBtn').addEventListener('click', () => {
            this.navigateToSection('dashboard');
        });

        // View all buttons
        document.getElementById('viewAllTransactionsBtn').addEventListener('click', () => {
            this.navigateToSection('transactions');
        });

        // Modal controls
        document.getElementById('closeModalBtn').addEventListener('click', () => {
            this.closeModal('addTransactionModal');
        });

        document.getElementById('closeWalletModalBtn').addEventListener('click', () => {
            this.closeModal('addWalletModal');
        });

        document.getElementById('cancelTransactionBtn').addEventListener('click', () => {
            this.closeModal('addTransactionModal');
        });

        document.getElementById('cancelWalletBtn').addEventListener('click', () => {
            this.closeModal('addWalletModal');
        });

        // Form submissions
        document.getElementById('transactionForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addTransaction();
        });

        document.getElementById('walletForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addWallet();
        });

        // Filter tabs
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.addEventListener('click', (e) => {
                this.setActiveFilterTab(e.currentTarget);
                this.filterTransactions();
            });
        });

        // Debt tabs
        document.querySelectorAll('.debt-tab').forEach(tab => {
            tab.addEventListener('click', (e) => {
                this.setActiveDebtTab(e.currentTarget);
                this.filterDebts();
            });
        });

        // Add buttons
        document.getElementById('addWalletBtn').addEventListener('click', () => {
            this.openModal('addWalletModal');
        });

        document.getElementById('addDebtBtn').addEventListener('click', () => {
            this.showNotification('Fitur tambah utang akan segera hadir!', 'info');
        });

        document.getElementById('addBudgetBtn').addEventListener('click', () => {
            this.showNotification('Fitur tambah budget akan segera hadir!', 'info');
        });

        document.getElementById('addRecurringBtn').addEventListener('click', () => {
            this.showNotification('Fitur transaksi berulang akan segera hadir!', 'info');
        });

        // Icon picker
        document.querySelectorAll('.icon-option').forEach(option => {
            option.addEventListener('click', (e) => {
                this.selectIcon(e.currentTarget);
            });
        });

        // Chart filter
        document.getElementById('expenseChartFilter').addEventListener('change', () => {
            this.updateExpenseChart();
        });
    }

    // Navigation
    navigateToSection(section) {
        // Hide all sections
        document.querySelectorAll('section').forEach(s => {
            s.classList.add('hidden');
        });

        // Show target section
        document.getElementById(section + 'Section').classList.remove('hidden');

        // Update navigation
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-section="${section}"]`).classList.add('active');

        this.currentSection = section;

        // Render section content
        switch(section) {
            case 'dashboard':
                this.renderDashboard();
                break;
            case 'transactions':
                this.renderTransactions();
                break;
            case 'wallets':
                this.renderWallets();
                break;
            case 'budget':
                this.renderBudgets();
                break;
            case 'debts':
                this.renderDebts();
                break;
            case 'recurring':
                this.renderRecurring();
                break;
        }
    }

    // Dashboard Rendering
    renderDashboard() {
        this.updateBalanceCards();
        this.renderRecentTransactions();
        this.updateCharts();
    }

    updateBalanceCards() {
        const totalBalance = this.wallets.reduce((sum, wallet) => sum + wallet.balance, 0);
        const monthlyIncome = this.getMonthlyAmount('income');
        const monthlyExpense = this.getMonthlyAmount('expense');

        document.getElementById('totalBalance').textContent = this.formatCurrency(totalBalance);
        document.getElementById('monthlyIncome').textContent = this.formatCurrency(monthlyIncome);
        document.getElementById('monthlyExpense').textContent = this.formatCurrency(monthlyExpense);
    }

    getMonthlyAmount(type) {
        const currentMonth = new Date().getMonth() + 1;
        const currentYear = new Date().getFullYear();
        
        return this.transactions
            .filter(t => {
                const transactionDate = new Date(t.date);
                return t.type === type && 
                       transactionDate.getMonth() + 1 === currentMonth &&
                       transactionDate.getFullYear() === currentYear;
            })
            .reduce((sum, t) => sum + t.amount, 0);
    }

    renderRecentTransactions() {
        const container = document.getElementById('recentTransactionsList');
        const recentTransactions = this.transactions
            .sort((a, b) => new Date(b.date + ' ' + b.time) - new Date(a.date + ' ' + a.time))
            .slice(0, 5);

        container.innerHTML = recentTransactions.map(transaction => {
            const category = this.categories.find(c => c.id === transaction.categoryId);
            const wallet = this.wallets.find(w => w.id === transaction.walletId);
            
            return `
                <div class="transaction-item">
                    <div class="transaction-icon ${transaction.type}">
                        <i class="${category?.icon || 'fas fa-question'}"></i>
                    </div>
                    <div class="transaction-details">
                        <div class="transaction-title">${transaction.description}</div>
                        <div class="transaction-category">${category?.name || 'Unknown'} • ${wallet?.name || 'Unknown'}</div>
                    </div>
                    <div class="transaction-amount">
                        <div class="transaction-amount ${transaction.type}">
                            ${transaction.type === 'income' ? '+' : '-'}${this.formatCurrency(transaction.amount)}
                        </div>
                        <div class="transaction-date">${this.formatDate(transaction.date)}</div>
                    </div>
                </div>
            `;
        }).join('');
    }

    // Transactions Rendering
    renderTransactions() {
        this.renderAllTransactions();
    }

    renderAllTransactions() {
        const container = document.getElementById('allTransactionsList');
        const sortedTransactions = this.transactions
            .sort((a, b) => new Date(b.date + ' ' + b.time) - new Date(a.date + ' ' + a.time));

        container.innerHTML = sortedTransactions.map(transaction => {
            const category = this.categories.find(c => c.id === transaction.categoryId);
            const wallet = this.wallets.find(w => w.id === transaction.walletId);
            
            return `
                <div class="transaction-item">
                    <div class="transaction-icon ${transaction.type}">
                        <i class="${category?.icon || 'fas fa-question'}"></i>
                    </div>
                    <div class="transaction-details">
                        <div class="transaction-title">${transaction.description}</div>
                        <div class="transaction-category">${category?.name || 'Unknown'} • ${wallet?.name || 'Unknown'}</div>
                    </div>
                    <div class="transaction-amount">
                        <div class="transaction-amount ${transaction.type}">
                            ${transaction.type === 'income' ? '+' : '-'}${this.formatCurrency(transaction.amount)}
                        </div>
                        <div class="transaction-date">${this.formatDate(transaction.date)}</div>
                    </div>
                </div>
            `;
        }).join('');
    }

    // Wallets Rendering
    renderWallets() {
        const container = document.getElementById('walletsGrid');
        
        container.innerHTML = this.wallets.map(wallet => `
            <div class="wallet-card">
                <div class="wallet-header">
                    <div class="wallet-icon" style="background-color: ${wallet.color}">
                        <i class="${wallet.icon}"></i>
                    </div>
                    <div class="wallet-name">${wallet.name}</div>
                </div>
                <div class="wallet-balance">${this.formatCurrency(wallet.balance)}</div>
                <div class="wallet-change">Saldo saat ini</div>
            </div>
        `).join('');
    }

    // Budgets Rendering
    renderBudgets() {
        const container = document.getElementById('budgetList');
        
        container.innerHTML = this.budgets.map(budget => {
            const category = this.categories.find(c => c.id === budget.categoryId);
            const percentage = (budget.spent / budget.amount) * 100;
            const isOverBudget = budget.spent > budget.amount;
            
            return `
                <div class="budget-item">
                    <div class="budget-header">
                        <div class="budget-category">${category?.name || 'Unknown'}</div>
                        <div class="budget-amount">${this.formatCurrency(budget.spent)} / ${this.formatCurrency(budget.amount)}</div>
                    </div>
                    <div class="budget-progress">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${Math.min(percentage, 100)}%; background-color: ${isOverBudget ? '#ef4444' : '#6366f1'}"></div>
                        </div>
                        <div class="progress-text">
                            <span>${percentage.toFixed(1)}%</span>
                            <span>${isOverBudget ? 'Melebihi budget' : 'Tersisa ' + this.formatCurrency(budget.amount - budget.spent)}</span>
                        </div>
                    </div>
                </div>
            `;
        }).join('');
    }

    // Debts Rendering
    renderDebts() {
        this.filterDebts();
    }

    filterDebts() {
        const activeTab = document.querySelector('.debt-tab.active');
        const type = activeTab.dataset.type;
        const container = document.getElementById('debtList');
        
        const filteredDebts = this.debts.filter(debt => debt.type === type);
        
        container.innerHTML = filteredDebts.map(debt => `
            <div class="debt-item">
                <div class="debt-header">
                    <div class="debt-person">${debt.personName}</div>
                    <div class="debt-amount">${this.formatCurrency(debt.amount)}</div>
                </div>
                <div class="debt-details">
                    <div class="debt-date">Jatuh tempo: ${this.formatDate(debt.dueDate)}</div>
                    <div class="debt-status ${debt.isSettled ? 'settled' : 'pending'}">
                        ${debt.isSettled ? 'Lunas' : 'Belum Lunas'}
                    </div>
                </div>
                ${debt.description ? `<div class="debt-description">${debt.description}</div>` : ''}
            </div>
        `).join('');
    }

    // Recurring Transactions Rendering
    renderRecurring() {
        const container = document.getElementById('recurringList');
        
        container.innerHTML = this.recurringTransactions.map(recurring => {
            const category = this.categories.find(c => c.id === recurring.categoryId);
            const wallet = this.wallets.find(w => w.id === recurring.walletId);
            
            return `
                <div class="recurring-item">
                    <div class="recurring-header">
                        <div class="recurring-title">${recurring.description}</div>
                        <div class="recurring-frequency">${this.getFrequencyText(recurring.frequency)}</div>
                    </div>
                    <div class="recurring-details">
                        <div class="recurring-amount">${this.formatCurrency(recurring.amount)}</div>
                        <div class="recurring-next">Berikutnya: ${this.formatDate(recurring.nextOccurrence)}</div>
                    </div>
                </div>
            `;
        }).join('');
    }

    // Charts
    initializeCharts() {
        this.createExpenseChart();
        this.createTrendChart();
    }

    createExpenseChart() {
        const ctx = document.getElementById('expenseChart').getContext('2d');
        const expenseData = this.getExpenseDataByCategory();
        
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: expenseData.labels,
                datasets: [{
                    data: expenseData.amounts,
                    backgroundColor: [
                        '#ef4444', '#f59e0b', '#ec4899', '#06b6d4', '#8b5cf6', '#10b981'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                }
            }
        });
    }

    createTrendChart() {
        const ctx = document.getElementById('trendChart').getContext('2d');
        const trendData = this.getTrendData();
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: trendData.labels,
                datasets: [{
                    label: 'Pemasukan',
                    data: trendData.income,
                    backgroundColor: '#10b981',
                    borderRadius: 4
                }, {
                    label: 'Pengeluaran',
                    data: trendData.expense,
                    backgroundColor: '#ef4444',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'Rp ' + value.toLocaleString('id-ID');
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            usePointStyle: true
                        }
                    }
                }
            }
        });
    }

    getExpenseDataByCategory() {
        const currentMonth = new Date().getMonth() + 1;
        const currentYear = new Date().getFullYear();
        
        const expenseCategories = this.categories.filter(c => c.type === 'expense');
        const data = expenseCategories.map(category => {
            const amount = this.transactions
                .filter(t => {
                    const transactionDate = new Date(t.date);
                    return t.type === 'expense' && 
                           t.categoryId === category.id &&
                           transactionDate.getMonth() + 1 === currentMonth &&
                           transactionDate.getFullYear() === currentYear;
                })
                .reduce((sum, t) => sum + t.amount, 0);
            
            return { name: category.name, amount };
        }).filter(item => item.amount > 0);
        
        return {
            labels: data.map(item => item.name),
            amounts: data.map(item => item.amount)
        };
    }

    getTrendData() {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'];
        const currentMonth = new Date().getMonth();
        
        return {
            labels: months.slice(0, currentMonth + 1),
            income: [5000000, 5200000, 4800000, 5500000, 5000000, 5000000].slice(0, currentMonth + 1),
            expense: [3200000, 3500000, 2800000, 4000000, 3000000, 750000].slice(0, currentMonth + 1)
        };
    }

    updateExpenseChart() {
        // Recreate chart with new data
        this.createExpenseChart();
    }

    updateCharts() {
        this.createExpenseChart();
        this.createTrendChart();
    }

    // Modal Functions
    openModal(modalId) {
        const modal = document.getElementById(modalId);
        modal.classList.add('show');
    }

    closeModal(modalId) {
        const modal = document.getElementById(modalId);
        modal.classList.remove('show');
    }

    openTransactionModal(type) {
        this.populateWalletOptions();
        this.populateCategoryOptions(type);
        document.getElementById('transactionType').value = type;
        document.getElementById('modalTitle').textContent = `Tambah ${type === 'income' ? 'Pemasukan' : 'Pengeluaran'}`;
        this.openModal('addTransactionModal');
    }

    populateWalletOptions() {
        const select = document.getElementById('transactionWallet');
        select.innerHTML = '<option value="">Pilih Dompet</option>' +
            this.wallets.map(wallet => 
                `<option value="${wallet.id}">${wallet.name}</option>`
            ).join('');
    }

    populateCategoryOptions(type) {
        const select = document.getElementById('transactionCategory');
        const filteredCategories = this.categories.filter(c => c.type === type);
        select.innerHTML = '<option value="">Pilih Kategori</option>' +
            filteredCategories.map(category => 
                `<option value="${category.id}">${category.name}</option>`
            ).join('');
    }

    // Form Handlers
    addTransaction() {
        const form = document.getElementById('transactionForm');
        const formData = new FormData(form);
        
        const transaction = {
            id: Date.now(),
            type: document.getElementById('transactionType').value,
            amount: parseInt(document.getElementById('transactionAmount').value),
            walletId: parseInt(document.getElementById('transactionWallet').value),
            categoryId: parseInt(document.getElementById('transactionCategory').value),
            description: document.getElementById('transactionDescription').value || 'Transaksi',
            date: document.getElementById('transactionDate').value,
            time: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
        };

        this.transactions.push(transaction);
        
        // Update wallet balance
        const wallet = this.wallets.find(w => w.id === transaction.walletId);
        if (wallet) {
            if (transaction.type === 'income') {
                wallet.balance += transaction.amount;
            } else {
                wallet.balance -= transaction.amount;
            }
        }

        this.closeModal('addTransactionModal');
        this.showNotification('Transaksi berhasil ditambahkan!', 'success');
        
        // Refresh current view
        if (this.currentSection === 'dashboard') {
            this.renderDashboard();
        } else if (this.currentSection === 'transactions') {
            this.renderTransactions();
        }
    }

    addWallet() {
        const form = document.getElementById('walletForm');
        const selectedIcon = document.querySelector('.icon-option.selected');
        
        const wallet = {
            id: Date.now(),
            name: document.getElementById('walletName').value,
            balance: parseInt(document.getElementById('walletBalance').value),
            icon: selectedIcon ? selectedIcon.dataset.icon : 'fas fa-wallet',
            color: '#6366f1'
        };

        this.wallets.push(wallet);
        this.closeModal('addWalletModal');
        this.showNotification('Dompet berhasil ditambahkan!', 'success');
        
        if (this.currentSection === 'wallets') {
            this.renderWallets();
        }
    }

    // Utility Functions
    selectIcon(iconElement) {
        document.querySelectorAll('.icon-option').forEach(option => {
            option.classList.remove('selected');
        });
        iconElement.classList.add('selected');
    }

    setActiveFilterTab(activeTab) {
        document.querySelectorAll('.filter-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        activeTab.classList.add('active');
    }

    setActiveDebtTab(activeTab) {
        document.querySelectorAll('.debt-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        activeTab.classList.add('active');
    }

    filterTransactions() {
        const activeTab = document.querySelector('.filter-tab.active');
        const filter = activeTab.dataset.filter;
        
        // This would filter transactions based on the selected filter
        // For now, we'll just re-render all transactions
        this.renderAllTransactions();
    }

    filterDebts() {
        this.renderDebts();
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount).replace('IDR', '').trim();
    }

    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('id-ID', {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        });
    }

    getFrequencyText(frequency) {
        const frequencies = {
            'daily': 'Harian',
            'weekly': 'Mingguan',
            'monthly': 'Bulanan',
            'yearly': 'Tahunan'
        };
        return frequencies[frequency] || frequency;
    }

    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;
        
        // Style the notification
        Object.assign(notification.style, {
            position: 'fixed',
            top: '20px',
            right: '20px',
            background: type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#6366f1',
            color: 'white',
            padding: '12px 20px',
            borderRadius: '8px',
            boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)',
            zIndex: '10000',
            transform: 'translateX(100%)',
            transition: 'transform 0.3s ease-in-out'
        });
        
        document.body.appendChild(notification);
        
        // Animate in
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 100);
        
        // Remove after 3 seconds
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 3000);
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new DompetinAja();
});

// Add some CSS for notifications
const notificationStyles = document.createElement('style');
notificationStyles.textContent = `
    .notification {
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        font-weight: 500;
    }
`;
document.head.appendChild(notificationStyles);
