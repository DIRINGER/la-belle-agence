import { useState, useMemo } from 'react';

const S = {
  section:  { background: 'white', border: '1px solid #E5E7EB', borderRadius: '10px', padding: '20px', marginBottom: '16px' },
  label:    { display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontWeight: '600', fontSize: '13px', color: '#374151', marginBottom: '6px' },
  valeur:   (couleur) => ({ fontWeight: '700', color: couleur, fontSize: '15px' }),
  slider:   { width: '100%', accentColor: '#1E3A8A', cursor: 'pointer' },
  kpiGrid:  { display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: '14px', marginBottom: '16px' },
  kpi:      (bg, color) => ({ background: bg, border: `1px solid ${color}33`, borderRadius: '10px', padding: '14px' }),
  montant:  (couleur) => ({ margin: 0, fontSize: '22px', fontWeight: '800', color: couleur }),
  kpiLabel: { margin: '2px 0 0', fontSize: '12px', color: '#6B7280' },
  row:      { display: 'flex', justifyContent: 'space-between', padding: '9px 0', borderBottom: '1px solid #F3F4F6', fontSize: '14px' },
  rowLast:  { display: 'flex', justifyContent: 'space-between', padding: '9px 0', fontSize: '14px' },
};

function fmt(v) {
  return v.toLocaleString('fr-FR', { minimumFractionDigits: 0, maximumFractionDigits: 0 }) + ' €';
}

function fmtDec(v) {
  return v.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' €';
}

function Slider({ label, name, min, max, step, value, onChange, format, couleur = '#1E3A8A' }) {
  return (
    <div style={{ marginBottom: '18px' }}>
      <div style={S.label}>
        <span>{label}</span>
        <span style={S.valeur(couleur)}>{format(value)}</span>
      </div>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={e => onChange(name, Number(e.target.value))}
        style={S.slider}
      />
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', color: '#9CA3AF', marginTop: '2px' }}>
        <span>{format(min)}</span>
        <span>{format(max)}</span>
      </div>
    </div>
  );
}

export default function SimulateurCredit({ couleur = '#1E3A8A' }) {
  const [params, setParams] = useState({
    prix_bien:     250000,
    apport:         25000,
    duree:              20,
    taux_interet:     3.50,
    taux_assurance:   0.25,
    type_bien:     'ancien',
  });

  function setParam(name, value) {
    setParams(prev => ({ ...prev, [name]: value }));
  }

  const calc = useMemo(() => {
    const { prix_bien, apport, duree, taux_interet, taux_assurance, type_bien } = params;

    const capital          = Math.max(0, prix_bien - apport);
    const n                = duree * 12;
    const tauxMensuel      = taux_interet / 100 / 12;
    const tauxAssurMensuel = taux_assurance / 100 / 12;

    let mensualiteCapital = 0;
    if (tauxMensuel > 0 && n > 0) {
      mensualiteCapital = capital * (tauxMensuel * Math.pow(1 + tauxMensuel, n)) / (Math.pow(1 + tauxMensuel, n) - 1);
    } else if (n > 0) {
      mensualiteCapital = capital / n;
    }

    const assuranceMensuelle = capital * tauxAssurMensuel;
    const mensualiteTotale   = mensualiteCapital + assuranceMensuelle;
    const coutTotalCredit    = mensualiteCapital * n - capital;
    const coutTotalAssurance = assuranceMensuelle * n;

    // Frais de notaire : ~7.5% ancien, ~2.5% neuf
    const tauxNotaire        = type_bien === 'neuf' ? 0.025 : 0.075;
    const fraisNotaire       = prix_bien * tauxNotaire;

    const coutTotalAcquisition = prix_bien + coutTotalCredit + coutTotalAssurance + fraisNotaire;
    const salaireMinimum       = mensualiteTotale / 0.33;

    // Taux endettement pour un salaire donné (calcul inversé)
    const tauxEndettemmentMedSalaire = (mensualiteTotale / (salaireMinimum)) * 100;

    return {
      capital,
      mensualiteCapital,
      assuranceMensuelle,
      mensualiteTotale,
      coutTotalCredit,
      coutTotalAssurance,
      fraisNotaire,
      coutTotalAcquisition,
      salaireMinimum,
      tauxEndettemmentMedSalaire,
    };
  }, [params]);

  const apportPct = params.prix_bien > 0 ? Math.round((params.apport / params.prix_bien) * 100) : 0;

  return (
    <div>
      {/* En-tête */}
      <div style={{ background: `linear-gradient(135deg, ${couleur} 0%, #2563EB 100%)`, color: 'white', borderRadius: '12px', padding: '20px 24px', marginBottom: '20px' }}>
        <h2 style={{ margin: '0 0 4px', fontSize: '20px' }}>🧮 Simulateur de Crédit Immobilier</h2>
        <p style={{ margin: 0, opacity: 0.85, fontSize: '13px' }}>Calculez votre mensualité, coût total et salaire minimum requis</p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', alignItems: 'start' }}>
        {/* Panneau de paramètres */}
        <div>
          <div style={S.section}>
            <h3 style={{ margin: '0 0 16px', color: couleur, fontSize: '15px' }}>🏠 Le bien</h3>

            <div style={{ marginBottom: '14px' }}>
              <label style={S.label}>
                <span>Type de bien</span>
                <span style={S.valeur(couleur)}>{params.type_bien === 'neuf' ? 'Neuf (frais ~2,5%)' : 'Ancien (frais ~7,5%)'}</span>
              </label>
              <div style={{ display: 'flex', gap: '8px' }}>
                {['ancien', 'neuf'].map(t => (
                  <button
                    key={t}
                    onClick={() => setParam('type_bien', t)}
                    style={{ flex: 1, padding: '8px', border: `2px solid ${params.type_bien === t ? couleur : '#E5E7EB'}`, borderRadius: '6px', background: params.type_bien === t ? couleur : 'white', color: params.type_bien === t ? 'white' : '#374151', cursor: 'pointer', fontWeight: '600', fontSize: '13px' }}
                  >
                    {t === 'neuf' ? '🏗️ Neuf' : '🏚️ Ancien'}
                  </button>
                ))}
              </div>
            </div>

            <Slider label="Prix du bien" name="prix_bien" min={50000} max={1500000} step={5000} value={params.prix_bien} onChange={setParam} format={fmt} couleur={couleur} />
            <Slider label={`Apport personnel (${apportPct}%)`} name="apport" min={0} max={Math.min(params.prix_bien, 500000)} step={1000} value={Math.min(params.apport, params.prix_bien)} onChange={setParam} format={fmt} couleur="#059669" />
          </div>

          <div style={S.section}>
            <h3 style={{ margin: '0 0 16px', color: couleur, fontSize: '15px' }}>💳 Le prêt</h3>
            <Slider label="Durée du prêt" name="duree" min={5} max={30} step={1} value={params.duree} onChange={setParam} format={v => `${v} ans`} couleur={couleur} />
            <Slider label="Taux d'intérêt (hors assurance)" name="taux_interet" min={0.5} max={8} step={0.05} value={params.taux_interet} onChange={setParam} format={v => `${v.toFixed(2)} %`} couleur="#D97706" />
            <Slider label="Taux d'assurance" name="taux_assurance" min={0.05} max={1} step={0.01} value={params.taux_assurance} onChange={setParam} format={v => `${v.toFixed(2)} %`} couleur="#7C3AED" />
          </div>
        </div>

        {/* Résultats */}
        <div>
          {/* KPI principaux */}
          <div style={S.kpiGrid}>
            <div style={S.kpi('#EFF6FF', '#2563EB')}>
              <p style={S.montant('#1E3A8A')}>{fmtDec(calc.mensualiteTotale)}</p>
              <p style={S.kpiLabel}>Mensualité totale</p>
            </div>
            <div style={S.kpi('#FFF7ED', '#D97706')}>
              <p style={S.montant('#D97706')}>{fmt(calc.coutTotalCredit)}</p>
              <p style={S.kpiLabel}>Coût total du crédit</p>
            </div>
            <div style={S.kpi('#F0FDF4', '#059669')}>
              <p style={S.montant('#059669')}>{fmt(calc.fraisNotaire)}</p>
              <p style={S.kpiLabel}>Frais de notaire (~{params.type_bien === 'neuf' ? '2,5' : '7,5'}%)</p>
            </div>
            <div style={S.kpi('#FDF4FF', '#7C3AED')}>
              <p style={S.montant('#7C3AED')}>{fmt(Math.ceil(calc.salaireMinimum))}</p>
              <p style={S.kpiLabel}>Salaire net min. requis</p>
            </div>
          </div>

          {/* Détail mensualité */}
          <div style={S.section}>
            <h3 style={{ margin: '0 0 14px', color: couleur, fontSize: '15px' }}>📊 Détail de la mensualité</h3>
            <div style={S.row}>
              <span>Capital emprunté</span>
              <strong>{fmt(calc.capital)}</strong>
            </div>
            <div style={S.row}>
              <span>Mensualité (capital + intérêts)</span>
              <strong>{fmtDec(calc.mensualiteCapital)}</strong>
            </div>
            <div style={S.row}>
              <span>Assurance mensuelle</span>
              <strong>{fmtDec(calc.assuranceMensuelle)}</strong>
            </div>
            <div style={{ ...S.rowLast, fontWeight: '700', background: '#F8FAFC', borderRadius: '6px', padding: '10px', marginTop: '4px' }}>
              <span style={{ color: couleur }}>Mensualité totale</span>
              <span style={{ color: couleur, fontSize: '16px' }}>{fmtDec(calc.mensualiteTotale)}</span>
            </div>
          </div>

          {/* Coût total acquisition */}
          <div style={S.section}>
            <h3 style={{ margin: '0 0 14px', color: couleur, fontSize: '15px' }}>💰 Coût total d'acquisition</h3>
            <div style={S.row}>
              <span>Prix du bien</span>
              <strong>{fmt(params.prix_bien)}</strong>
            </div>
            <div style={S.row}>
              <span>Apport personnel</span>
              <strong style={{ color: '#059669' }}>- {fmt(params.apport)}</strong>
            </div>
            <div style={S.row}>
              <span>Coût total du crédit (intérêts)</span>
              <strong>{fmt(calc.coutTotalCredit)}</strong>
            </div>
            <div style={S.row}>
              <span>Coût total assurance ({params.duree} ans)</span>
              <strong>{fmt(calc.coutTotalAssurance)}</strong>
            </div>
            <div style={S.row}>
              <span>Frais de notaire</span>
              <strong>{fmt(calc.fraisNotaire)}</strong>
            </div>
            <div style={{ ...S.rowLast, fontWeight: '700', background: '#FEF3C7', borderRadius: '6px', padding: '10px', marginTop: '4px' }}>
              <span style={{ color: '#D97706' }}>Coût total d'acquisition</span>
              <span style={{ color: '#D97706', fontSize: '16px' }}>{fmt(calc.coutTotalAcquisition)}</span>
            </div>
          </div>

          {/* Taux d'endettement */}
          <div style={{ ...S.section, background: calc.salaireMinimum > 0 ? '#F0FDF4' : '#FEF3C7', borderColor: '#059669' }}>
            <h3 style={{ margin: '0 0 10px', color: '#059669', fontSize: '15px' }}>📏 Règle des 33% (taux d'endettement)</h3>
            <p style={{ margin: '0 0 8px', fontSize: '13px', color: '#374151' }}>
              Pour un taux d'endettement de <strong>33%</strong>, le salaire net mensuel minimum requis est :
            </p>
            <p style={{ margin: 0, fontSize: '24px', fontWeight: '800', color: '#059669' }}>
              {fmt(Math.ceil(calc.salaireMinimum))} / mois
            </p>
            <p style={{ margin: '6px 0 0', fontSize: '12px', color: '#6B7280' }}>
              (mensualité {fmtDec(calc.mensualiteTotale)} ÷ 0,33 = salaire minimum)
            </p>
          </div>

          {/* Note légale */}
          <p style={{ fontSize: '11px', color: '#9CA3AF', textAlign: 'center', marginTop: '4px' }}>
            Simulation indicative — Ne constitue pas une offre de crédit. Consultez un courtier agréé pour un calcul personnalisé.
          </p>
        </div>
      </div>
    </div>
  );
}
