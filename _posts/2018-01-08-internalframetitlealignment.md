---
layout: post
category: swing
folder: InternalFrameTitleAlignment
title: JInternalFrameのタイトルを左寄せに変更する
tags: [JInternalFrame, NimbusLookAndFeel, LookAndFeel]
author: aterai
pubdate: 2018-01-08T21:07:11+09:00
description: NimbusLookAndFeelを使用するJInternalFrameのタイトルを左寄せに変更します。
image: https://drive.google.com/uc?id=1pc7-91VPZY42IsKoQuMfcpg0I90siJvvlQ
comments: true
---
## 概要
`NimbusLookAndFeel`を使用する`JInternalFrame`のタイトルを左寄せに変更します。

{% download https://drive.google.com/uc?id=1pc7-91VPZY42IsKoQuMfcpg0I90siJvvlQ %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.setLookAndFeel("javax.swing.plaf.nimbus.NimbusLookAndFeel");
UIDefaults def = UIManager.getLookAndFeelDefaults();
def.put("InternalFrame:InternalFrameTitlePane.titleAlignment", "LEADING");
</code></pre>

## 解説
上記のサンプルでは、`UIDefaults`の`InternalFrame:InternalFrameTitlePane.titleAlignment`キーの値を変更することで`NimbusLookAndFeel`を使用する`JInternalFrame`のタイトルを変更しています。

- メモ
    - `TRAILING`で右寄せになる
    - `SynthLookAndFeel`系でのみ有効
    - `JInternalFrame#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`を設定すると、各ボタンと合わせて、タイトルの字揃えも逆転する
        - `NorthPane#setComponentOrientation(...)`は効果がない
    - 個別の`JInternalFrame`でタイトルの字揃えを変更する場合は、以下のように`JInternalFrame#getUI()`で取得した`BasicInternalFrameUI`から`getNorthPane()`でタイトルバーを取得し、`putClientProperty("Nimbus.Overrides", ...)`で上書きする
    - `JInternalFrame#putClientProperty(...)`は効果がない
    - この方法でもすべての`JInternalFrame`のタイトル字揃えが変更されてしまう場合がある？
        
        <pre class="prettyprint"><code>JInternalFrame frame = new JInternalFrame("title", true, true, true, true);
        BasicInternalFrameUI ui = (BasicInternalFrameUI) frame.getUI();
        JComponent titleBar = (JComponent) ui.getNorthPane();
        UIDefaults d = new UIDefaults();
        String titleAlignment = idx == 0 ? "CENTER" : "LEADING";
        d.put("InternalFrame:InternalFrameTitlePane.titleAlignment", titleAlignment);
        titleBar.putClientProperty("Nimbus.Overrides", d);
</code></pre>
    - * 参考リンク [#reference]
- [BasicInternalFrameUI#getNorthPane() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicInternalFrameUI.html#getNorthPane--)

<!-- dummy comment line for breaking list -->

## コメント
