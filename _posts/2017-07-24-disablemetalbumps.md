---
layout: post
category: swing
folder: DisableMetalBumps
title: MetalLookAndFeelのJInternalFrameタイトルバーでBumpsを非表示にする
tags: [JInternalFrame, MetalLookAndFeel, LookAndFeel]
author: aterai
pubdate: 2017-07-24T15:44:08+09:00
description: MetalLookAndFeelのJInternalFrameでBumpsを非表示にし、フラットなタイトルバーに変更します。
image: https://drive.google.com/uc?id=1Iy8Oe01o_AOQbIeiuE_pEjfkegKcJuPexQ
comments: true
---
## 概要
`MetalLookAndFeel`の`JInternalFrame`で`Bumps`を非表示にし、フラットなタイトルバーに変更します。

{% download https://drive.google.com/uc?id=1Iy8Oe01o_AOQbIeiuE_pEjfkegKcJuPexQ %}

## サンプルコード
<pre class="prettyprint"><code>JInternalFrame f1 = new JInternalFrame("basic", true, true, true, true) {
  @Override public void updateUI() {
    super.updateUI();
    setUI(new BasicInternalFrameUI(this) {
      @Override protected JComponent createNorthPane(JInternalFrame w) {
        return new BumpsFreeInternalFrameTitlePane(w);
      }
    });
  }
};
//...
class BumpsFreeInternalFrameTitlePane extends BasicInternalFrameTitlePane {
  protected BumpsFreeInternalFrameTitlePane(JInternalFrame w) {
    super(w);
    setBorder(BorderFactory.createMatteBorder(
        0, 0, 1, 0, MetalLookAndFeel.getPrimaryControlDarkShadow()));
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.height = 24;
    return d;
  }
  @Override public void createButtons() {
    super.createButtons();
    Arrays.asList(closeButton, maxButton, iconButton).forEach(b -&gt; {
      b.setContentAreaFilled(false);
      b.setBorder(BorderFactory.createEmptyBorder(2, 5, 2, 5));
    });
  }
}
</code></pre>

## 解説
- `metal(default)`
    - デフォルトの`MetalLookAndFeel`
- `basic`
    - `MetalBumps`クラスはパッケージプライベートなので外部から色などを変更して非表示にするのが難しい
    - 代わりに`BasicInternalFrameTitlePane`に`MetalInternalFrameTitlePane`のボタンアイコンや縁などを設定してフラットなタイトルバーを作成
        - タイトルバーの高さを`BasicInternalFrameTitlePane#getPreferredSize()`メソッドをオーバーライドして設定
        - 閉じるボタンなどの余白設定が効かない？
        - フォーカスが無い場合の縁色に未対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MetalInternalFrameTitlePane (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/metal/MetalInternalFrameTitlePane.html)

<!-- dummy comment line for breaking list -->

## コメント
