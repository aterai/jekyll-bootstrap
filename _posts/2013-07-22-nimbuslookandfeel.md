---
layout: post
category: swing
folder: NimbusLookAndFeel
title: NimbusLookAndFeelを使用する
tags: [LookAndFeel, NimbusLookAndFeel, UIManager]
author: aterai
pubdate: 2013-07-22T01:35:03+09:00
description: LookAndFeel一覧からNimbusLookAndFeelを名前で検索取得して使用します。
image: https://lh5.googleusercontent.com/-40dXjNq1HbU/UewL67WFpWI/AAAAAAAABwg/zOHVr2U7KiM/s800/NimbusLookAndFeel.png
comments: true
---
## 概要
`LookAndFeel`一覧から`NimbusLookAndFeel`を名前で検索取得して使用します。[Nimbus Look and Feel (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/nimbus.html)などのサンプルから引用しています。

{% download https://lh5.googleusercontent.com/-40dXjNq1HbU/UewL67WFpWI/AAAAAAAABwg/zOHVr2U7KiM/s800/NimbusLookAndFeel.png %}

## サンプルコード
<pre class="prettyprint"><code>try {
  UIManager.setLookAndFeel("javax.swing.plaf.nimbus.NimbusLookAndFeel");
  // // 以下はJDK 1.7.0 以前を考慮する必要がある場合の指定方法
  // for (UIManager.LookAndFeelInfo laf: UIManager.getInstalledLookAndFeels()) {
  //   if ("Nimbus".equals(laf.getName())) {
  //     UIManager.setLookAndFeel(laf.getClassName());
  //   }
  // }
} catch (ClassNotFoundException | InstantiationException
       | IllegalAccessException | UnsupportedLookAndFeelException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
`JDK 1.7.0`で`NimbusLookAndFeel`のパッケージが移動されて完全クラス名が変更されたので、`JDK 1.6.0_10`との互換性を考慮する場合は注意が必要です。

- `JDK 1.6.0_10`: `com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel`
    - 一旦`UIManager.getInstalledLookAndFeels()`で全`LookAndFeelInfo`を取得し名前が`Nimbus`となっている`LookAndFeel`を検索してその完全クラス名を取得
- `JDK 1.7.0`以降: `javax.swing.plaf.nimbus.NimbusLookAndFeel`
    - 完全クラス名から`NimbusLookAndFeel`のインスタンスを生成して設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Nimbus Look and Feel (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/nimbus.html)

<!-- dummy comment line for breaking list -->

## コメント
