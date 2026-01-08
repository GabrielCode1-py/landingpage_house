# Monitor de Propagação DNS - Railway
# Execute: .\monitor_dns.ps1

Write-Host "`n🔍 MONITOR DE PROPAGAÇÃO DNS - RAILWAY`n" -ForegroundColor Cyan -BackgroundColor Black
Write-Host "Domínio: housealimentoss.com.br" -ForegroundColor White
Write-Host "Servidor: Railway (66.33.22.112)`n" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray

$tentativas = 0
$maxTentativas = 20

while ($tentativas -lt $maxTentativas) {
    $tentativas++
    
    Write-Host "[$tentativas/$maxTentativas] Testando..." -ForegroundColor Yellow
    
    try {
        $response = Invoke-WebRequest -Uri "https://housealimentoss.com.br" -UseBasicParsing -TimeoutSec 10
        
        Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "🎉 SITE ONLINE E FUNCIONANDO!" -ForegroundColor Green -BackgroundColor Black
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "`n✅ Status HTTP: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "📦 Tamanho: $([math]::Round($response.Content.Length/1024, 2)) KB" -ForegroundColor Cyan
        Write-Host "🔒 HTTPS: Ativo" -ForegroundColor Green
        Write-Host "🌐 URL: https://housealimentoss.com.br" -ForegroundColor Cyan
        Write-Host "☁️  Servidor: Railway" -ForegroundColor Cyan
        Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "🎊 SUCESSO! Pode desligar o PC!`n" -ForegroundColor Green -BackgroundColor Black
        
        # Testar elementos principais
        if ($response.Content -match 'HOUSE Alimentos') {
            Write-Host "✅ Título do site: OK" -ForegroundColor Green
        }
        if ($response.Content -match 'main.js') {
            Write-Host "✅ JavaScript: Carregado" -ForegroundColor Green
        }
        if ($response.Content -match 'style.css') {
            Write-Host "✅ CSS: Carregado" -ForegroundColor Green
        }
        
        Write-Host "`n🧪 TESTE AGORA:" -ForegroundColor Cyan
        Write-Host "   1. Abra: https://housealimentoss.com.br" -ForegroundColor White
        Write-Host "   2. Teste menu hamburger" -ForegroundColor White
        Write-Host "   3. Teste carrosséis" -ForegroundColor White
        Write-Host "   4. Teste formulários" -ForegroundColor White
        Write-Host "`n✅ Propagação concluída!`n" -ForegroundColor Green
        
        break
        
    } catch {
        Write-Host "   ⏳ Aguardando... (DNS ainda propagando)" -ForegroundColor Gray
        
        if ($tentativas -eq $maxTentativas) {
            Write-Host "`n⚠️ Limite de tentativas atingido" -ForegroundColor Yellow
            Write-Host "💡 Possíveis causas:" -ForegroundColor Cyan
            Write-Host "   1. DNS ainda propagando (pode levar até 24h)" -ForegroundColor White
            Write-Host "   2. Verifique configuração no Cloudflare:" -ForegroundColor White
            Write-Host "      - CNAME @ deve apontar para URL do Railway" -ForegroundColor White
            Write-Host "      - Proxy deve estar OFF (cinza, não laranja)" -ForegroundColor White
            Write-Host "   3. Verifique domínio customizado no Railway" -ForegroundColor White
            Write-Host "`n🔄 Execute novamente: .\monitor_dns.ps1`n" -ForegroundColor Yellow
        }
        
        Start-Sleep -Seconds 15
    }
}
