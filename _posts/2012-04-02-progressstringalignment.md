---
layout: post
title: JProgressBarの進捗文字列の字揃えを変更する
category: swing
folder: ProgressStringAlignment
tags: [JProgressBar, JLabel, BorderLayout, Alignment]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-04-02

## 概要
`JProgressBar`の進捗文字列を`JLabel`にして、字揃えなどを変更します。

{% download https://lh5.googleusercontent.com/-zRMPjXT7do4/T3lYdJUnilI/AAAAAAAABLA/kcpMYSYoklM/s800/ProgressStringAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>JProgressBar bar = new JProgressBar(model) {
  private final JLabel label = new JLabel(getString(), halign);
  private final ChangeListener changeListener = new ChangeListener() {
    @Override public void stateChanged(ChangeEvent e) {
      label.setText(getString());
    }
  };
  @Override public void updateUI() {
    removeChangeListener(changeListener);
    removeAll();
    super.updateUI();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        setLayout(new BorderLayout());
        addChangeListener(changeListener);
        add(label);
        label.setBorder(BorderFactory.createEmptyBorder(0,4,0,4));
      }
    });
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JProgressBar`のレイアウトを`BorderLayout`に変更し、水平方向の配置方法を設定した`JLabel`を追加することで、字揃えを変更しています。

- 注:
    - `JProgressBar#setStringPainted(true)`を同時に使用すると、二重に表示される
    - 進捗状況に応じた文字色の変化には対応していない
    - `NimbusLookAndFeel`の場合で、`TitleBorder`などを直接`JProgressBar`に設定しても、進捗文字列の垂直位置がずれない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JProgressBarの文字列をJLayerを使って表示する](http://terai.xrea.jp/Swing/ProgressStringLayer.html)

<!-- dummy comment line for breaking list -->

## コメント
