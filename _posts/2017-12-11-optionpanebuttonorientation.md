---
layout: post
category: swing
folder: OptionPaneButtonOrientation
title: JOptionPaneのボタンの揃えを変更する
tags: [JOptionPane, UIManager, LookAndFeel]
author: aterai
pubdate: 2017-12-11T14:36:25+09:00
description: JOptionPaneの下部に表示されるオプションボタンの揃えを右揃えなどに変更します。
image: https://drive.google.com/uc?id=1GfIGoZXfe9MpKMUVblmQ68ek4z5tU-4cPw
comments: true
---
## 概要
`JOptionPane`の下部に表示されるオプションボタンの揃えを右揃えなどに変更します。

{% download https://drive.google.com/uc?id=1GfIGoZXfe9MpKMUVblmQ68ek4z5tU-4cPw %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("OptionPane.buttonOrientation", SwingConstants.RIGHT);
</code></pre>


## 解説
- `CENTER`
    - `UIManager.put("OptionPane.buttonOrientation", SwingConstants.CENTER)`で右揃えに変更
    - `MetalLookAndFeel`や`WindowsLookAndFeel`でのデフォルトは中央揃え
- `RIGHT`
    - `UIManager.put("OptionPane.buttonOrientation", SwingConstants.RIGHT)`で右揃えに変更
    - `NimbusLookAndFeel`や`GTKLookAndFeel`でのデフォルトは右揃え
- `LEFT`
    - `UIManager.put("OptionPane.buttonOrientation", SwingConstants.LEFT)`で左揃えに変更

<!-- dummy comment line for breaking list -->

- - - -
- `MotifLookAndFeel`のデフォルトは、両端揃えで`UIManager.put("OptionPane.buttonOrientation", ...)`の設定は無視される
- `JOptionPane#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`を設定すると、オプションボタンの揃えも反転する
    
    <pre class="prettyprint"><code>// 例えば以下の設定で、"message"は右寄せ、オプションボタンは左寄せになる
    UIManager.put("OptionPane.buttonOrientation", SwingConstants.RIGHT);
    JOptionPane op = new JOptionPane("message", JOptionPane.PLAIN_MESSAGE, JOptionPane.YES_NO_OPTION);
    op.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
    op.createDialog(getRootPane(), "title").setVisible(true);
</code></pre>
- * 参考リンク [#reference]
- [JOptionPaneで使用するボタンのサイズを揃える](https://ateraimemo.com/Swing/SameSizeButtons.html)

<!-- dummy comment line for breaking list -->

## コメント
