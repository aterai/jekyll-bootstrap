---
layout: post
title: NimbusLookAndFeelを使用する
category: swing
folder: NimbusLookAndFeel
tags: [LookAndFeel, NimbusLookAndFeel, UIManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-07-22

## NimbusLookAndFeelを使用する
`LookAndFeel`一覧から`NimbusLookAndFeel`を名前で検索取得して使用します。[Nimbus Look and Feel (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](http://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/nimbus.html)などのサンプルから引用しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-40dXjNq1HbU/UewL67WFpWI/AAAAAAAABwg/zOHVr2U7KiM/s800/NimbusLookAndFeel.png)

### サンプルコード
<pre class="prettyprint"><code>try{
  for(UIManager.LookAndFeelInfo laf: UIManager.getInstalledLookAndFeels()) {
    if("Nimbus".equals(laf.getName())) {
      UIManager.setLookAndFeel(laf.getClassName());
    }
  }
}catch(Exception e) {
  //e.printStackTrace();
}
</code></pre>

### 解説
`JDK 1.7.0`で`NimbusLookAndFeel`のパッケージが移動されて完全クラス名が変更されたので、`NimbusLookAndFeel`のインスタンスを生成して設定するのではなく、一旦`UIManager.getInstalledLookAndFeels()`で全`LookAndFeelInfo`を取得し、名前が`Nimbus`となっている`LookAndFeel`を検索してからその完全クラス名を取得しています。

- `JDK 1.6.0_10`: `com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel`
- `JDK 1.7.0`: `javax.swing.plaf.nimbus.NimbusLookAndFeel`

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Nimbus Look and Feel (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](http://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/nimbus.html)

<!-- dummy comment line for breaking list -->

### コメント
