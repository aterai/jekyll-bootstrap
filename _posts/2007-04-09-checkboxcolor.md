---
layout: post
category: swing
folder: CheckBoxColor
title: JCheckBoxのチェックアイコンを変更
tags: [JCheckBox, Icon, UIManager]
author: aterai
pubdate: 2007-04-09T15:16:42+09:00
description: JCheckBoxで使用するチェックアイコンの色や形を変更します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTI225hC_I/AAAAAAAAATc/YxhkQ5Bq2sk/s800/CheckBoxColor.png
comments: true
---
## 概要
`JCheckBox`で使用するチェックアイコンの色や形を変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTI225hC_I/AAAAAAAAATc/YxhkQ5Bq2sk/s800/CheckBoxColor.png %}

## サンプルコード
<pre class="prettyprint"><code>class CheckBoxIcon2 implements Icon {
  private final Icon orgIcon = UIManager.getIcon("CheckBox.icon");
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.translate(x, y);
    orgIcon.paintIcon(c, g2, 0, 0);
    if (c instanceof AbstractButton) {
      AbstractButton b = (AbstractButton) c;
      ButtonModel model = b.getModel();
      g2.setColor(new Color(255, 155, 155, 100));
      g2.fillRect(2, 2, getIconWidth() - 4, getIconHeight() - 4);
      if (model.isSelected()) {
        g2.setColor(Color.RED);
        g2.drawLine(9, 3, 9, 3);
        g2.drawLine(8, 4, 9, 4);
        g2.drawLine(7, 5, 9, 5);
        g2.drawLine(6, 6, 8, 6);
        g2.drawLine(3, 7, 7, 7);
        g2.drawLine(4, 8, 6, 8);
        g2.drawLine(5, 9, 5, 9);
        g2.drawLine(3, 5, 3, 5);
        g2.drawLine(3, 6, 4, 6);
      }
    }
    g2.dispose();
  }
  @Override public int getIconWidth() {
    return orgIcon.getIconWidth();
  }
  @Override public int getIconHeight() {
    return orgIcon.getIconHeight();
  }
}
</code></pre>

## 解説
- `Default`
    - デフォルトの`JCheckBox`
- `WindowsIconFactory`
    - `com/sun/java/swing/plaf/windows/WindowsIconFactory.java`から、`XP`スタイルではない場合のアイコンをコピーし、一部色などを変更
- `CheckBox.icon+RED`
    - `UIManager.getIcon("CheckBox.icon")`で取得したオリジナルのアイコンを、アルファ値を設定した色で上書きし、✔マークも色を変えて塗り潰し
    - チェックの形は`WindowsIconFactory`からコピーしているので、別の`LookAndFeel`では枠からはみ出してしまう
- `MetalCheckBoxIcon+GRAY`
    - `javax.swing.plaf.metal.MetalCheckBoxIcon`をアルファ値を設定した色で上書き

<!-- dummy comment line for breaking list -->

- - - -
`Windows XP`スタイル以外を使用する環境で色を変更する場合は、以下のような方法もあります。

<pre class="prettyprint"><code>System.setProperty("swing.noxp", "true");
UIManager.put("CheckBox.interiorBackground", new ColorUIResource(Color.GREEN));
UIManager.put("CheckBox.darkShadow", new ColorUIResource(Color.RED));
JCheckBox cb = new JCheckBox("check box");
</code></pre>

## 参考リンク
- [進歩したSynth](https://www.ibm.com/developerworks/jp/java/library/j-synth/)
    - `SynthLookAndFeel`を使って、画像でチェックを描画するサンプルなどが紹介されている

<!-- dummy comment line for breaking list -->

## コメント
