function calcular() {
    let colmeia = Number(ipt_colmeias.value)
    let valorKg = Number(ipt_valorkg.value)
    let producao = Number(ipt_producao.value)
     if (colmeia <= 0, valorKg <= 0, producao <= 0) {
        resultado.innerHTML = "<span class ='vermelho'>Preencha todos os dados corretamente.</span>";

        return;
     }

     // Produção total
    let producaoTotal = colmeia * producao;

    // Receita ideal
    let receitaIdeal = producaoTotal * valorKg;

    // Sem monitoramento (15% de perda)
    let perdaSemSistema = producaoTotal * 0.15;
    let prejuizoSemSistema = perdaSemSistema * valorKg;
    let receitaSemSistema = receitaIdeal - prejuizoSemSistema;
    
    // Com monitoramento (5% de perda)
    let perdaComSitema = producaoTotal * 0.05;
    let prejuizoComSistema = perdaComSitema * valorKg;
    let receitaComSistema = receitaIdeal - prejuizoComSistema;

    // Economia 
    let economia = prejuizoSemSistema - prejuizoComSistema;

    resultado.innerHTML = `
    <h2>Resultado da simulação</h2>

    <b>Produção Total:</b> ${producaoTotal.toFixed(2)} kg <br><br>
    <b>Receita Ideal:</b> ${receitaIdeal.toFixed(2)} kg <br><br>

    <hr> 

    <h3>Sem o Colmeia Tech</h3>

    Perda de produção: <b>${perdaSemSistema.toFixed(2)} kg</b><br>

    Prejuízo: <span class = "vermelho">
    R$ ${prejuizoSemSistema.toFixed(2)}
    </span><br>

    Receita Final: <b>R$ ${receitaSemSistema.toFixed(2)}</b>

    <hr>

    <h3>Com o Colmeia Tech</h3>

    Perda de produção: <b>${perdaComSitema.toFixed(2)} kg</b><br>

    Prejuízo: <span class = "vermelho">
    R$ ${prejuizoComSistema.toFixed(2)}
    </span><br>

    Receita Final: <b>R$ ${receitaComSistema.toFixed(2)}</b>

    <hr>

    <h2>Economia Mensal </h2>

    <span class ="verde">
    R$ ${economia.toFixed(2)}
    </span>
    `;

    ipt_colmeias.value = "";
    ipt_producao.value = "";
    ipt_valorkg.value = "";
    }