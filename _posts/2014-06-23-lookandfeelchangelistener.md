---
layout: post
title: LookAndFeelの変更を取得する
category: swing
folder: LookAndFeelChangeListener
tags: [LookAndFeel, UIManager, PropertyChangeListener, JComponent]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-06-23

## LookAndFeelの変更を取得する
`LookAndFeel`の変更を取得するリスナーの作成などを行います。

{% download %}

![screenshot](https://lh3.googleusercontent.com/-dbduLE1mbyM/U6b3UwtJj6I/AAAAAAAACH4/AUy3dSpgxMg/s800/LookAndFeelChangeListener.png)

### サンプルコード
<pre class="prettyprint"><code>UIManager.addPropertyChangeListener(new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    if (e.getPropertyName().equals("lookAndFeel")) {
      //String lnf = e.getNewValue().toString();
      updateCheckBox("UIManager: propertyChange");
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、以下の三種類の方法で`LookAndFeel`の変更を取得するテストを行っています。

- `UIManager: propertyChange`
    - `UIManager.addPropertyChangeListener(PropertyChangeListener)`を使用して、`LookAndFeel`の変更を取得
    - このサンプルでは、初回の`UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());`の後で`PropertyChangeListener`を設定しているので、それには反応しない
- `JPanel: updateUI`
    - `LookAndFeel`の変更(`SwingUtilities.updateComponentTreeUI(...)`が実行)されると、必ず呼び出される`JComponent.updateUI()`をオーバーライドして変更を取得
    - このメソッドをオーバーライドしたコンポーネントのコンストラクタが実行される前に呼び出される場合があるので、子コンポーネントの更新は`EventQueue.invokeLater(...)`を使って一番最後に実行
- `JMenuItem: actionPerformed`
    - このサンプルでは、`JRadioButtonMenuItem`で`LookAndFeel`を切り替えているので、各ボタンに`ActionListener`を追加し、チェックされた時に`LookAndFeel`の変更を取得
    - アクションが実行された時点では、`LookAndFeel`の変更が完了しておらず、`UIManager`のプロパティ値も前の`LookAndFeel`のままなので、その値の取得は`EventQueue.invokeLater(...)`を使って一番最後に実行

<!-- dummy comment line for breaking list -->

### コメント
