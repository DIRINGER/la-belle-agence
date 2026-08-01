export function lancerConfettis() {
  const couleurs = ['#1E3A8A', '#059669', '#F59E0B', '#DC2626', '#7C3AED'];
  if (!document.getElementById('style-confettis')) {
    const style = document.createElement('style');
    style.id = 'style-confettis';
    style.textContent = `
      @keyframes chute-confetti {
        0% { transform: translateY(0) rotate(0deg); opacity: 0.95; }
        100% { transform: translateY(100vh) rotate(360deg); opacity: 0; }
      }
    `;
    document.head.appendChild(style);
  }
  for (let i = 0; i < 60; i++) {
    const piece = document.createElement('div');
    const couleur = couleurs[Math.floor(Math.random() * couleurs.length)];
    const gauche = Math.random() * 100;
    const delai = Math.random() * 0.4;
    const duree = 2 + Math.random() * 1.5;
    const taille = 6 + Math.random() * 6;
    piece.style.cssText = `
      position: fixed; top: -10px; left: ${gauche}vw; width: ${taille}px; height: ${taille}px;
      background: ${couleur}; opacity: 0.95; z-index: 9999; pointer-events: none;
      border-radius: ${Math.random() > 0.5 ? '50%' : '2px'};
      animation: chute-confetti ${duree}s ${delai}s ease-in forwards;
    `;
    document.body.appendChild(piece);
    setTimeout(() => piece.remove(), (duree + delai) * 1000 + 300);
  }
}
