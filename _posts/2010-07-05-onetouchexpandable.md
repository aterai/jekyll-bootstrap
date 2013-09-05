---
layout: post
title: JSplitPaneのディバイダを展開、収納する
category: swing
folder: OneTouchExpandable
tags: [JSplitPane, ActionMap, ServiceManager, BasicService]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-07-05

## JSplitPaneのディバイダを展開、収納する
`JSplitPane`のディバイダをマウスのクリックなどで一気に展開、収納できるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTQl4nQ4PI/AAAAAAAAAf0/y7DMbOexVWs/s800/OneTouchExpandable.png)

### サンプルコード
<pre class="prettyprint"><code>JSplitPane splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, s1, s2);
splitPane.setOneTouchExpandable(true);
</code></pre>

### 解説
上記のサンプルでは、`JSplitPane#setOneTouchExpandable(true)`と設定することで、ディバイダに`JButton`が表示され、これらをクリックすることでディバイダを展開、収納することができるようになっています。

- - - -
`Java 1.5`以降で`JSplitPane#setDividerLocation(0);`などとしてディバイダを収納状態にした場合、`JSplitPane`自体をリサイズすると収納されているコンポーネントの最小サイズ(`setMinimumSize`)まで展開されてしまいます。

- 収納状態を維持したい場合、リフレクションを使って、`BasicSplitPaneUI#setKeepHidden(true)`メソッドを実行したり、`Divider`に表示されている`JButton`を取得実行する方法があります。
    - [Bug ID: 5006095 Need a way to programmatically stick JSplitPane divider under j2sdk 1.5](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5006095)
    - [JSplitPaneの収納状態を維持する](http://terai.xrea.jp/Swing/KeepHiddenDivider.html)

<!-- dummy comment line for breaking list -->

- - - -
<kbd>HOME</kbd>キーや<kbd>END</kbd>キー(<kbd>F8</kbd>キーなどで`Divider`にフォーカスを移動した状態で)を押して展開、収納する方法では、`Divider`中の`JButton`を押して展開、収納した場合と動作が異なります。

- <kbd>HOME</kbd>キー、<kbd>END</kbd>キーで展開、収納
    - 前回の状態に一旦戻らずに展開、収納される
    - `JSplitPane`自体をリサイズすると、収納されているコンポーネントの最小サイズ(`setMinimumSize`)まで勝手に展開される
        - `JSplitPane#getActionMap()#get("selectMin")`などで取得できる`Action`では、`setKeepHidden(boolean)`が使われていない

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Bug ID: 5006095 Need a way to programmatically stick JSplitPane divider under j2sdk 1.5](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5006095)
- [JSplitPaneの収納状態を維持する](http://terai.xrea.jp/Swing/KeepHiddenDivider.html)

<!-- dummy comment line for breaking list -->

### コメント
- ソースファイルをダウンロードして`eclipse`でプロジェクト作成しそこにコピーしたのですが、「インポートされた `javax.jnlp` は見つかりません」と出てきて実行出来ないのですが、 `javax.jnlp`はどこに置けば良いのでしょうか？ -- [ニートン](http://terai.xrea.jp/ニートン.html) 2012-02-21 (火) 08:06:33
    - `eclipse`はほとんど使ったことがないのでインポートの詳細(もしかして`Ant`の`build.xml`を取り込む機能がある？)が分からないのですが、`javax.jnlp`パッケージは、`${java.home}/lib/javaws.jar`にあるので、ここにクラスパスが通っていないのかもしれません。このサンプルでは、`javax.jnlp.*`は使用しないので、`build.xml`から`<pathelement location="${java.home}/lib/javaws.jar" />`を削除するか、または、`eclipse`で新規プロジェクトを作成し、ソースコードだけ貼り付けるのが簡単だと思います。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-02-21 (火) 17:15:21
- ＞`eclipse`で新規プロジェクトを作成し、ソースコードだけ貼り付けるのが簡単だと思います。

<!-- dummy comment line for breaking list -->
その通りしていたのですが。。。結果的には`jnlp.jar`ファイルを`jdk1.6`の中から探して`eclipse`の「外部`jar`を追加」で動作いたしました。お騒がせしました。それと、この`javax.jnlpはBasicService`関連のクラスファイルが入ってるようなので削除できないみたいです。-- [ニートン](http://terai.xrea.jp/ニートン.html) 2012-02-22 (水) 18:41:04
    - すいません。「このサンプルでは、`javax.jnlp.*`は使用しないので...」はデタラメで、`BasicService`が取得できるかどうかで、`Web Start`で起動したのかどうかを判断する部分を見落としていました。`Web Start`で起動した場合は、`getComponents()`でボタンを検索する方法で、ローカルから起動した場合は、リフレクションで`private`な`setKeepHidden`メソッドを取得して実行する方法を使っています。大変失礼しましたm(__)m。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-02-22 (水) 18:59:52

<!-- dummy comment line for breaking list -->
