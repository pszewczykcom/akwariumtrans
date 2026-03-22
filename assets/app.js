import './stimulus_bootstrap.js';

const initializeMobileNavigation = () => {
    const navigation = document.querySelector('[data-mobile-nav]');

    if (!navigation || navigation.dataset.initialized === 'true') {
        return;
    }

    const toggle = navigation.querySelector('[data-mobile-nav-toggle]');
    const menu = navigation.querySelector('[data-mobile-nav-menu]');
    const openIcon = navigation.querySelector('[data-mobile-nav-open-icon]');
    const closeIcon = navigation.querySelector('[data-mobile-nav-close-icon]');

    if (!toggle || !menu) {
        return;
    }

    navigation.dataset.initialized = 'true';

    const setState = (isOpen) => {
        toggle.setAttribute('aria-expanded', String(isOpen));
        menu.classList.toggle('hidden', !isOpen && window.innerWidth < 1024);
        menu.classList.toggle('flex', isOpen || window.innerWidth >= 1024);

        if (openIcon && closeIcon) {
            openIcon.classList.toggle('hidden', isOpen);
            closeIcon.classList.toggle('hidden', !isOpen);
        }
    };

    let isDesktop = window.innerWidth >= 1024;

    setState(isDesktop);

    toggle.addEventListener('click', () => {
        const isOpen = toggle.getAttribute('aria-expanded') === 'true';
        setState(!isOpen);
    });

    menu.querySelectorAll('a').forEach((link) => {
        link.addEventListener('click', () => {
            if (window.innerWidth < 1024) {
                setState(false);
            }
        });
    });

    window.addEventListener('resize', () => {
        const nowDesktop = window.innerWidth >= 1024;

        if (nowDesktop !== isDesktop) {
            isDesktop = nowDesktop;
            setState(nowDesktop);
        }
    });
};

document.addEventListener('DOMContentLoaded', initializeMobileNavigation);
document.addEventListener('turbo:load', initializeMobileNavigation);
