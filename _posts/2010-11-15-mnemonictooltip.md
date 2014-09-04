---
layout: post
title: JToolTipにJButtonのMnemonicを表示
category: swing
folder: MnemonicToolTip
tags: [JToolTip, JButton, Mnemonic]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-11-15

## 概要
`JButton`に`Mnemonic`が設定されている場合、`JToolTip`にそれを表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTP7StneAI/AAAAAAAAAew/RwPtDfNOEyg/s800/MnemonicToolTip.png %}

## サンプルコード
<pre class="prettyprint"><code>class MnemonicToolTip extends JToolTip {
  private final JLabel mnemonicLabel = new JLabel();
  public MnemonicToolTip() {
    setLayout(new BorderLayout());
    mnemonicLabel.setForeground(Color.GRAY);
    mnemonicLabel.setBorder(BorderFactory.createEmptyBorder(0,2,0,2));
    add(mnemonicLabel, BorderLayout.EAST);
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    if(mnemonicLabel.isVisible()) {
      d.width += mnemonicLabel.getPreferredSize().width;
    }
    return d;
  }
  @Override public void setComponent(JComponent c) {
    if(c instanceof AbstractButton) {
      AbstractButton b = (AbstractButton)c;
      int mnemonic = b.getMnemonic();
      if(mnemonic&gt;0) {
        mnemonicLabel.setVisible(true);
        mnemonicLabel.setText("Alt+"+KeyEvent.getKeyText(mnemonic));
      }else{
        mnemonicLabel.setVisible(false);
      }
    }
    super.setComponent(c);
  }
}
</code></pre>

## 解説
- 上
    - `setToolTipText`で直接`Mnemonic`を追加
- 下
    - `JToolTip`に`BorderLayout`を設定して、`Mnemonic`用の`JLabel`を追加

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JToolTipにアイコンを表示](http://terai.xrea.jp/Swing/ToolTipIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
