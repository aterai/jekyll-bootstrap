---
layout: post
category: swing
folder: SpinnerButton
title: JSpinnerのボタンにToolTipを付ける
tags: [JSpinner, JButton, JToolTip]
author: aterai
pubdate: 2007-07-23T15:06:56+09:00
description: JSpinnerの上下ボタンにJToolTipを付けます。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTmW4UoMI/AAAAAAAAAks/SXmtS71QSg0/s800/SpinnerButton.png
comments: true
---
## 概要
`JSpinner`の上下ボタンに`JToolTip`を付けます。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTmW4UoMI/AAAAAAAAAks/SXmtS71QSg0/s800/SpinnerButton.png %}

## サンプルコード
<pre class="prettyprint"><code>private static class MySpinnerUI extends BasicSpinnerUI {
  @Override protected Component createNextButton() {
    JComponent nextButton = (JComponent) super.createNextButton();
    nextButton.setToolTipText("SpinnerUI: next next");
    return nextButton;
  }
  @Override protected Component createPreviousButton() {
    JComponent previousButton = (JComponent) super.createPreviousButton();
    previousButton.setToolTipText("SpinnerUI: prev prev");
    return previousButton;
  }
}
</code></pre>
<pre class="prettyprint"><code>private static void searchSpinnerButtons(Container comp) {
  for (Component c: comp.getComponents()) {
    if ("Spinner.nextButton".equals(c.getName())) {
      ((JButton) c).setToolTipText("getName: next next");
    } else if ("Spinner.previousButton".equals(c.getName())) {
      ((JButton) c).setToolTipText("getName: prev prev");
    } else if (c instanceof Container) {
      searchSpinnerButtons((Container) c);
    }
  }
}
</code></pre>

## 解説
- 上:
    - `BasicSpinnerUI`を継承する`SpinnerUI`を作成し、`createNextButton`、`createPreviousButton`メソッドをオーバーライドして、`ToolTipText`を設定
- 中:
    - 名前が`Spinner.nextButton`、`Spinner.previousButton`となっているコンポーネントを検索して、`ToolTipText`を設定
    - `WindowsLookAndFeel`(`XP`スタイル)の場合、`JSpinner`の各ボタンに名前が付けられていないため、正常に動作しない
- 下:
    - `Windows`環境の場合は`WindowsSpinnerUI`を継承して、それ以外の場合は、名前で検索して`ToolTipText`を設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BasicSpinnerUI#createNextButton() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicSpinnerUI.html#createNextButton--)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: [Bug ID: 5036022 JSpinner does not reflect new font on subsequent calls to setFont](https://bugs.openjdk.java.net/browse/JDK-5036022)、[JSpinnerのフォント指定 - kaisehのブログ](http://d.hatena.ne.jp/kaiseh/20071120/1195560201) -- *aterai* 2007-11-26 (月) 12:10:19

<!-- dummy comment line for breaking list -->
